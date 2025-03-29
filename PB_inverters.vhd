library ieee;
use ieee.std_logic_1164.all;

-- declaring input and output signals for pb inverters
entity PB_inverters is port (
	rst_n				: in	std_logic;
	rst				: out std_logic;
 	pb_n_filtered	: in  std_logic_vector (3 downto 0);
	pb					: out	std_logic_vector(3 downto 0)							 
	); 
end PB_inverters;

-- declaring architecture for pb inverters
architecture ckt of PB_inverters is

begin
-- inverting signals
rst <= NOT(rst_n);
pb <= NOT(pb_n_filtered);


end ckt;