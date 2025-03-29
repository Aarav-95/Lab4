---------------------
-- Lab Session: 205
-- Team Number: 24
-- Group Names: Aarav Patel, Aryan Tiwari
---------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- declaring input and output signals of state machine
Entity State_Machine IS Port
(
	clk_input, reset, blink_sig				: IN std_logic;
	EW_pedestrian_crossing, NS_pedestrian_crossing 		: IN std_logic;
	mode_control, sm_clken					: IN std_logic;
	EW_register_clear, NS_register_clear			: OUT std_logic;
	EW_crossing_light_display, NS_crossing_light_display	: OUT std_logic;
	state_number						: OUT std_logic_vector(3 downto 0);
	EW_DOUT, NS_DOUT					: OUT std_logic_vector(6 downto 0)
);
END ENTITY;


-- architecture definition for state machine
Architecture SM of state_machine is

-- declaring all states as a type
TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values


SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


BEGIN

-------------------------------------------------------------------------------
--State Machine:
-------------------------------------------------------------------------------

-- register section of state machine to trigger state machine to transition appropriately as per the clock
Register_Section: PROCESS (clk_input)  -- this process updates with a clock input
BEGIN
	-- state machine updates on rising edge
	IF(rising_edge(clk_input)) THEN
		-- checking for reset signal
		IF (reset = '1') THEN
			current_state <= S0;
		-- checking if state machine is enabled
		ELSIF (reset = '0' and sm_clken = '1') THEN
			current_state <= next_state;
		END IF;
	END IF;
END PROCESS;	

-- logic for state machine transitioning from one state to the next
Transition_Section: PROCESS (current_state) 

BEGIN
	CASE current_state IS
		WHEN S0 =>
			-- state jump if only EW pedestrian crossing is requested
			IF (EW_pedestrian_crossing = '1' and NS_pedestrian_crossing = '0') THEN
				next_state <= S6;
			ELSE
				next_state <= s1;
			END IF;
		WHEN S1 =>
			-- state jump if only EW pedestrian crossing is requested		
			IF (EW_pedestrian_crossing = '1' and NS_pedestrian_crossing = '0') THEN
				next_state <= S6;
			ELSE
				next_state <= s2;
			END IF;
		WHEN S2 =>		
			next_state <= S3;
		WHEN S3 =>		
			next_state <= S4;
		WHEN S4 =>		
			next_state <= S5;
		WHEN S5 =>		
			next_state <= S6;
		WHEN S6 =>		
			next_state <= S7;
		WHEN S7 =>		
			next_state <= S8;
		WHEN S8 =>
			-- state jump if only NW pedestrian crossing is requested
			IF (NS_pedestrian_crossing = '1' and EW_pedestrian_crossing = '0') THEN
				next_state <= S14;
			ELSE
				next_state <= s9;
			END IF;
		WHEN S9 =>
			-- state jump if only NW pedestrian crossing is requested
			IF (NS_pedestrian_crossing = '1' and EW_pedestrian_crossing = '0') THEN
				next_state <= S14;
			ELSE
				next_state <= s10;
			END IF;
		WHEN S10 =>		
			next_state <= S11;
		WHEN S11 =>		
			next_state <= S12;
		WHEN S12 =>		
			next_state <= S13;
		WHEN S13 =>		
			next_state <= S14;
		WHEN S14 =>		
			next_state <= S15;
		WHEN OTHERS =>
			-- checking for offline mode
			IF (mode_control = '1') THEN
				-- keeping state at state 15
				next_state <= current_state;
			ELSE
				next_state <= S0;
			END IF;
			next_state <= S0;
			
	END CASE;
END PROCESS;


-- decoder section defines the behaviour of the machine at each state (i.e. output signals, etc.)
Decoder_Section: PROCESS (current_state)

BEGIN
		-- default values for all signals
		EW_register_clear <= '0';
		NS_register_clear <= '0';

		EW_crossing_light_display <= '0';
		NS_crossing_light_display <= '0';

     CASE current_state IS
	  
         WHEN S0 =>
		 	-- incorporating blink_sig for flashing green
			NS_DOUT <= "000" & blink_sig & "000";
			EW_DOUT <= "0000001";
			state_number <= "0000";
			
         WHEN S1 =>
		 	-- incorporating blink_sig for flashing green
			NS_DOUT <= "000" & blink_sig & "000";
			EW_DOUT <= "0000001";
			state_number <= "0001";

         WHEN S2 =>
		 	-- activating crossing light		
			NS_DOUT <= "0001000";
			EW_DOUT <= "0000001";
			NS_crossing_light_display <= '1';
			state_number <= "0010";
			
         WHEN S3 =>		
			NS_DOUT <= "0001000";
			EW_DOUT <= "0000001";
			NS_crossing_light_display <= '1';
			state_number <= "0011";

         WHEN S4 =>		
			NS_DOUT <= "0001000";
			EW_DOUT <= "0000001";
			NS_crossing_light_display <= '1';
			state_number <= "0100";

         WHEN S5 =>		
			NS_DOUT <= "0001000";
			EW_DOUT <= "0000001";
			NS_crossing_light_display <= '1';
			state_number <= "0101";
				
         WHEN S6 =>		
			NS_DOUT <= "1000000";
			EW_DOUT <= "0000001";
			NS_register_clear <= '1';
			state_number <= "0110";
				
         WHEN S7 =>		
			NS_DOUT <= "1000000";
			EW_DOUT <= "0000001";
			state_number <= "0111";
			
			WHEN S8 =>	
			-- incorporating blink_sig for flashing green	
			NS_DOUT <= "0000001";
			EW_DOUT <= "000" & blink_sig & "000";
			NS_register_clear <= '0';
			state_number <= "1000";
			
			WHEN S9 =>
			-- incorporating blink_sig for flashing green		
			NS_DOUT <= "0000001";
			EW_DOUT <= "000" & blink_sig & "000";
			NS_register_clear <= '0';
			state_number <= "1001";
			
			WHEN S10 =>		
			NS_DOUT <= "0000001";
			EW_DOUT <= "0001000";
			EW_crossing_light_display <= '1';
			state_number <= "1010";
			
			WHEN S11 =>		
			NS_DOUT <= "0000001";
			EW_DOUT <= "0001000";
			EW_crossing_light_display <= '1';
			state_number <= "1011";
			
			WHEN S12 =>		
			NS_DOUT <= "0000001";
			EW_DOUT <= "0001000";
			EW_crossing_light_display <= '1';
			state_number <= "1100";
			
			WHEN S13 =>		
			NS_DOUT <= "0000001";
			EW_DOUT <= "0001000";
			EW_crossing_light_display <= '1';
			state_number <= "1101";
			
			WHEN S14 =>		
			NS_DOUT <= "0000001";
			EW_DOUT <= "1000000";
			EW_register_clear <= '1';
			state_number <= "1110";
			
			WHEN S15 =>	
			-- checking for offline mode	
			IF (mode_control = '1') THEN
				-- incorporating blink_sig for flashing red and yellow
				NS_DOUT <= "000000" & blink_sig;
				EW_DOUT <= blink_sig & "000000";
			ELSE
				NS_DOUT <= "0000001";
				EW_DOUT <= "1000000";
			END IF;
			state_number <= "1111";
			
         WHEN others =>		
 			NS_DOUT <= "0000000";
			EW_DOUT <= "0000000";
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
