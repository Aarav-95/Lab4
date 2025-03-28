---------------------
-- Lab Session: 205
-- Team Number: 24
-- Group Names: Aarav Patel, Aryan Tiwari
---------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration for holding register (inputs and outputs)
entity holding_register is port (

			clk				: in std_logic;
			reset				: in std_logic;
			register_clr			: in std_logic;
			din				: in std_logic;
			dout				: out std_logic
  );
 end holding_register;

-- Architecture declaration for holding register
architecture circuit of holding_register is

	-- Signal defined for process below
	Signal sreg				: std_logic;


BEGIN
	-- Beginning of process (Behavioural VHDL) where sensitivity list only consists of clk (changes in clk activates process)
	Holding_register_process: PROCESS(clk)
	BEGIN
		-- Only runs if clk has rising edge
		IF (rising_edge(clk)) THEN
			-- If statement to clear holding register
			IF (reset = '1' or register_clr = '1') THEN
				sreg <= '0';
			-- Else statement if clear functions not active
			ELSE
				sreg <= din or sreg;
			END IF;
		END IF;
	END PROCESS;
	
	dout <= sreg;
	
end;
