--Copyright 2025 Andrey S. Ionisyan (anserion@gmail.com)
--Licensed under the Apache License, Version 2.0 (the "License");
--you may not use this file except in compliance with the License.
--You may obtain a copy of the License at
--    http://www.apache.org/licenses/LICENSE-2.0
--Unless required by applicable law or agreed to in writing, software
--distributed under the License is distributed on an "AS IS" BASIS,
--WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--See the License for the specific language governing permissions and
--limitations under the License.
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

entity UART_TX_top is
    Port (SYS_CLK,KEY1: in STD_LOGIC; LED1,UART_TX: out STD_LOGIC);
end UART_TX_top;

architecture Behavioral of UART_TX_top is
component CLK_GEN
   Port (CLK_IN,EN,RESET: in STD_LOGIC;
         LOW_NUM, HIGH_NUM: natural;
         CLK_OUT : out  STD_LOGIC);
end component;
component send_byte
  Port (CLK,STB: in STD_LOGIC; DIN: in STD_LOGIC_VECTOR (7 downto 0);
        TX,RDY: out STD_LOGIC);
end component;

signal send_stb_reg: std_logic:='0';
signal send_byte_ok: std_logic:='0';
signal CLK, CLK_UART: std_logic:='0';

begin
  LED1<=not(KEY1);
  CLK_GEN_1MHz_chip: CLK_GEN port map(SYS_CLK,'1','0',25,25,CLK);
  --CLK_GEN_9600Hz_chip: CLK_GEN port map(SYS_CLK,'1','0',2400,2400,CLK_UART); --unstable
  CLK_GEN_10kHz_chip: CLK_GEN port map(SYS_CLK,'1','0',2500,2500,CLK_UART); --stable
  SEND_BYTE_chip: send_byte port map(CLK_UART,send_stb_reg,"01000001",UART_TX,send_byte_ok);
  
  process(clk)
  constant debounce: natural := 1000;
  variable fsm: natural range 0 to 7:=0;
  variable cnt: natural range 0 to 1023:=0;
  begin
    if rising_edge(CLK) then
      case fsm is
      when 0=> if KEY1='0' then fsm:=1; cnt:=0; end if;
      when 1=> if cnt=debounce then fsm:=2; else cnt:=cnt+1; end if;
      when 2=> if send_byte_ok='1' then fsm:=3; send_stb_reg<='1'; end if;
      when 3=> if send_byte_ok='0' then fsm:=4; send_stb_reg<='0'; end if;
      when 4=> if KEY1='1' then fsm:=5; cnt:=0; end if;
      when 5=> if cnt=debounce then fsm:=0; else cnt:=cnt+1; end if;
      when others=>null;
      end case;
    end if;
  end process;
end Behavioral;
