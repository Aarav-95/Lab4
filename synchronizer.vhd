library ieee;
use ieee.std_logic_1164.all;


entity synchronizer is port (

			clk			: in std_logic;
			reset		: in std_logic;
			din			: in std_logic;
			dout		: out std_logic
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0);

BEGIN

	Sync_process : PROCESS(clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			IF (reset = '1') THEN
				sreg <= "00";
			
			ELSE
				sreg(1) <= sreg(0);
				sreg(0) <= din;
			END IF;
		END IF;
	END PROCESS;
	dout <= sreg(1);
end;