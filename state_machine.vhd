library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity State_Machine IS Port
(
 clk_input, reset, blink_sig									: IN std_logic;
 EW_pedestrian_crossing, NS_pedestrian_crossing 		: IN std_logic;
 mode_control, sm_clken											: IN std_logic;
 EW_register_clear, NS_register_clear						: OUT std_logic;
 EW_crossing_light_display, NS_crossing_light_display	: OUT std_logic;
 state_number														: OUT std_logic_vector(3 downto 0);
 EW_DOUT, NS_DOUT													: OUT std_logic_vector(6 downto 0)
 );
END ENTITY;
 

 Architecture SM of state_machine is
 
 

 
 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


 BEGIN
 

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------
 
Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN
		IF (reset = '1') THEN
			current_state <= S0;
		ELSIF (reset = '0' and sm_clken = '1') THEN
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	

Transition_Section: PROCESS (current_state) 

BEGIN
	CASE current_state IS
		WHEN S0 =>
			IF (EW_pedestrian_crossing = '1' and NS_pedestrian_crossing = '0') THEN
				next_state <= S6;
			ELSE
				next_state <= s1;
			END IF;
		WHEN S1 =>		
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
			IF (NS_pedestrian_crossing = '1' and EW_pedestrian_crossing = '0') THEN
				next_state <= S14;
			ELSE
				next_state <= s9;
			END IF;
		WHEN S9 =>
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
--			IF (mode_control = '1') THEN
--				next_state <= current_state;
--			ELSE
--				next_state <= S0;
--			END IF;
			next_state <= S0;
			
	END CASE;
END PROCESS;

Decoder_Section: PROCESS (current_state)

BEGIN

		EW_register_clear <= '0';
		NS_register_clear <= '0';

		EW_crossing_light_display <= '0';
		NS_crossing_light_display <= '0';

     CASE current_state IS
	  
         WHEN S0 =>		
			NS_DOUT <= "000" & blink_sig & "000";
			EW_DOUT <= "0000001";
			state_number <= "0000";
			
         WHEN S1 =>		
			NS_DOUT <= "000" & blink_sig & "000";
			EW_DOUT <= "0000001";
			state_number <= "0001";

         WHEN S2 =>		
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
			NS_DOUT <= "0000001";
			EW_DOUT <= "000" & blink_sig & "000";
			NS_register_clear <= '0';
			state_number <= "1000";
			
			WHEN S9 =>		
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
			IF (mode_control = '1') THEN
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
