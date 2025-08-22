LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
 
ENTITY tb_UART_TX IS
END tb_UART_TX;
 
ARCHITECTURE behavior OF tb_UART_TX IS 
    COMPONENT UART_TX_top
    PORT(SYS_CLK,KEY1: IN std_logic; LED1: OUT std_logic; UART_TX: OUT std_logic);
    END COMPONENT;
   --Inputs
   signal SYS_CLK: std_logic := '0';
   signal KEY1: std_logic := '1';
 	--Outputs
   signal LED1,UART_TX: std_logic;
   -- Clock period definitions
   constant SYS_CLK_period : time := 10 ns;
   -- others
   signal clk_cnt: natural:=0;
BEGIN
   uut: UART_TX_top PORT MAP (SYS_CLK,KEY1,LED1,UART_TX);
   -- Clock process definitions
   SYS_CLK_process :process
   begin
		SYS_CLK <= '0';
		wait for SYS_CLK_period/2;
		SYS_CLK <= '1';
		wait for SYS_CLK_period/2;
      clk_cnt<=clk_cnt+1;
   end process;
   -- Stimulus process
   stim_proc: process
   begin		
      wait for SYS_CLK_period;
      if clk_cnt=100000 then key1<='0'; end if;
      if clk_cnt=200000 then key1<='1'; end if;
      if clk_cnt=300000 then key1<='0'; end if;
      if clk_cnt=400000 then key1<='1'; end if;
      if clk_cnt=500000 then key1<='0'; end if;
      if clk_cnt=600000 then key1<='1'; end if;
      if clk_cnt=700000 then wait; end if;
   end process;
END;