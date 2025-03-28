---------------------
-- Lab Session: 205
-- Team Number: 24
-- Group Names: Aarav Patel, Aryan Tiwari
---------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
    clkin_50	    : in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
    leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	sm_clken  : buffer std_logic;
	blink_sig : buffer std_logic;
	NS_a : out	std_logic;
	NS_d : out	std_logic;
	NS_g : out	std_logic;
	EW_a : out	std_logic;
	EW_d : out	std_logic;
	EW_g : out	std_logic;
   seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

   component segment7_mux port (
          clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
	component synchronizer port(
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
   end component; 
  component holding_register port (
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
  end component;

  component state_machine port (
			clk_input, reset, blink_sig									: IN std_logic;
			EW_pedestrian_crossing, NS_pedestrian_crossing 			: IN std_logic;
			mode_control, sm_clken											: IN std_logic;
			EW_register_clear, NS_register_clear						: OUT std_logic;
			EW_crossing_light_display, NS_crossing_light_display	: OUT std_logic;
			state_number														: OUT std_logic_vector(3 downto 0);
			EW_DOUT, NS_DOUT													: OUT std_logic_vector(6 downto 0)
  );
  end component;
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode													: boolean := TRUE;  -- set to FALSE for LogicalStep board downloads																						-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			   		: std_logic;
--	SIGNAL sm_clken, blink_sig										: std_logic;
	SIGNAL pb_n_filtered, pb, synch_pb							: std_logic_vector(3 downto 0);
	
	SIGNAL NS_pedestrian_crossing, EW_pedestrian_crossing : std_logic;
	SIGNAL NS_register_clear, EW_register_clear				: std_logic;
	SIGNAL NS_traffic_light_display, EW_traffic_light_display	: std_logic_vector(6 downto 0);
	SIGNAL mode_control                                   : std_logic := '0';

	
BEGIN
----------------------------------------------------------------------------------------------------
INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: synchronizer     port map (clkin_50,'0', rst, synch_rst);
INST3: synchronizer     port map (clkin_50, synch_rst, pb(1), synch_pb(1));	
INST4: synchronizer     port map (clkin_50, synch_rst, pb(0), synch_pb(0));	
INST5: synchronizer		port map (clkin_50, synch_rst, sw(0), mode_control);
INST6: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);
INST7: holding_register port map (clkin_50, synch_rst, EW_register_clear, synch_pb(1), EW_pedestrian_crossing);
INST8: holding_register port map (clkin_50, synch_rst, NS_register_clear, synch_pb(0), NS_pedestrian_crossing);
digit_display: segment7_mux port map(clkin_50,  NS_traffic_light_display, EW_traffic_light_display, seg7_data, seg7_char2, seg7_char1);
Traffic_Light: state_machine port map(clkin_50, synch_rst, blink_sig, EW_pedestrian_crossing, NS_pedestrian_crossing, mode_control, sm_clken, EW_register_clear, NS_register_clear, leds(2), leds(0), leds(7 downto 4), EW_traffic_light_display, NS_traffic_light_display);
	
	

leds(3) <= EW_pedestrian_crossing;
leds(1) <= NS_pedestrian_crossing;


END SimpleCircuit;
