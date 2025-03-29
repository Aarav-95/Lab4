library ieee;
use ieee.std_logic_1164.all;

-- defining input and output signals for synchronizer
entity synchronizer is port (

			clk			: in std_logic;
			reset		: in std_logic;
			din			: in std_logic;
			dout		: out std_logic
  );
 end synchronizer;
 
-- defining architecture for synchronizer 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0);

BEGIN

	Sync_process : PROCESS(clk) -- universal clock input
	-- through the sequential logic below, flip-flops are inferred
	BEGIN
		-- checking for rising edge
		IF (rising_edge(clk)) THEN
			-- checking for reset signal
			IF (reset = '1') THEN
				sreg <= "00";
			
			ELSE
				-- synchronizing output
				sreg(1) <= sreg(0);
				sreg(0) <= din;
			END IF;
		END IF;
	END PROCESS;
	-- setting output signal
	dout <= sreg(1);
end;