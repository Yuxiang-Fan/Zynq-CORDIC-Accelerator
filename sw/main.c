
#include "COMMON.h"

uint8_t Receive_Buffer2[4];
uint8_t Receive_Buffer[10];

int main(void)
{
    uint8_t Data[10];
    uint32_t Timeout;
    uint8_t i;

    ScuGic_Init();
    
    AXI_UartLite_Init(&AXI_UART0, XPAR_AXI_UARTLITE_0_DEVICE_ID);
    AXI_UARTLite_Intr_Init(&AXI_UART0, XPAR_FABRIC_AXI_UARTLITE_0_INTERRUPT_INTR,
            AXI_UART0_Send_IRQ_Handler,AXI_UART0_Recv_IRQ_Handler);

    PS_UART_Init(&UartPs1,XPAR_PS7_UART_1_DEVICE_ID, XUARTPS_OPER_MODE_NORMAL, 115200);
    PS_UART_Intr_Init(&UartPs1, PS_UART1_IRQ_ID, 8, (void *)PS_UART1_IRQ_Handler);

    while(1) {

        
        AXI_UARTLite_RecvData(&AXI_UART0, Receive_Buffer2, 4);
        PS_Uart_RecvData(&UartPs1, Receive_Buffer, 10);
        while(!(Recv_All_Flag || TimeOut_Flag || All_Recv_Flag));
        if(All_Recv_Flag) {
            
            All_Recv_Flag = 0;

            uint32_t value_32bit = (Receive_Buffer2[3] << 24) |
                                   (Receive_Buffer2[2] << 16) |
                                   (Receive_Buffer2[1] << 8)  |
                                   (Receive_Buffer2[0]);

            double data_point;
            const uint32_t SIGN_BIT_MASK = 0x80000000;

            int32_t signed_value = (int32_t)value_32bit;
            data_point = signed_value / 65536.0;

            char print_buffer[32];
            if (value_32bit >= SIGN_BIT_MASK) {
                snprintf(print_buffer, sizeof(print_buffer), "Value= %.4f \r\n", data_point);
            } else {
                snprintf(print_buffer, sizeof(print_buffer), "Value= %.4f \r\n", data_point);
            }
            PS_Uart_SendString(&UartPs1, print_buffer);
        }

        if(Recv_All_Flag) {
            Recv_All_Flag = 0;

            if(Receive_Buffer[0] == 'S') {  
                uint32_t hex_value = 0;
                char command = Receive_Buffer[9];
                switch(command) {
                    case 'A':
                    case 'a':
                        AXI_UARTLite_SendData32(&AXI_UART0, 0xaaaaaaaa);
                        break;
                    case 'B':
                    case 'b':
                        AXI_UARTLite_SendData32(&AXI_UART0, 0xbbbbbbbb);
                        break;
                    case 'C':
                    case 'c':
                        AXI_UARTLite_SendData32(&AXI_UART0, 0xcccccccc);
                        break;
                    case 'D':
                    case 'd':
                        AXI_UARTLite_SendData32(&AXI_UART0, 0xdddddddd);
                        break;
                    default: AXI_UARTLite_SendData32(&AXI_UART0, 0xaaaaaaaa);
                    break;      

                }
                for(i = 0; i < 8; i++) {
                    char c = Receive_Buffer[i + 1];
                    uint8_t nibble;
                    if(c >= '0' && c <= '9') {
                        nibble = c - '0';
                    } else if(c >= 'A' && c <= 'F') {
                        nibble = c - 'A' + 10;
                    } else if(c >= 'a' && c <= 'f') {
                        nibble = c - 'a' + 10;
                    } else {
                        nibble = 0;  
                    }
                    hex_value = (hex_value << 4) | nibble;
                }

                usleep(100000);
                AXI_UARTLite_SendData32(&AXI_UART0, hex_value);
            }
        } 

        if(TimeOut_Flag) {
            
            TimeOut_Flag = 0;
        }

    } 

    return 0;
} 
