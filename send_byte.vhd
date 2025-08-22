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
use IEEE.STD_LOGIC_1164.ALL, IEEE.STD_LOGIC_ARITH.ALL, ieee.std_logic_unsigned.all;

entity send_byte is
  Port (CLK,STB: in STD_LOGIC; DIN: in STD_LOGIC_VECTOR (7 downto 0);
        TX,RDY: out STD_LOGIC);
end send_byte;

architecture Behavioral of send_byte is
signal ready_reg,tx_reg: std_logic;
begin
  TX<=tx_reg; RDY<=ready_reg;
  process(CLK)
    variable fsm: natural range 0 to 15:=0;
  begin
    if rising_edge(CLK) then
       case fsm is
       when 0 => fsm:=1; ready_reg<='1'; tx_reg<='1'; -- init
       when 1 => if STB='1'
                 then fsm:=2; ready_reg<='0'; tx_reg<='0'; --start bit
                 end if;
       when 2 => fsm:=3; tx_reg<=DIN(0);
       when 3 => fsm:=4; tx_reg<=DIN(1);
       when 4 => fsm:=5; tx_reg<=DIN(2);
       when 5 => fsm:=6; tx_reg<=DIN(3);
       when 6 => fsm:=7; tx_reg<=DIN(4);
       when 7 => fsm:=8; tx_reg<=DIN(5);
       when 8 => fsm:=9; tx_reg<=DIN(6);
       when 9 => fsm:=10; tx_reg<=DIN(7);
       when 10=> fsm:=11;
                 tx_reg<=DIN(0) xor DIN(1) xor DIN(2) xor DIN(3) xor
                         DIN(4) xor DIN(5) xor DIN(6) xor DIN(7); --parity bit
       when 11 => fsm:=1; ready_reg<='1'; tx_reg<='1'; --stop bit
       when others => null;
       end case;
    end if;
  end process;
end Behavioral;
