library IEEE;
use IEEE.std_logic_1164.all;
use work.EE232.all;

entity DIGITAL_CLOCK is                                              -- Entity declaration
	
	port(CLK : in std_logic;                                          -- Clock input of the counter
		  --RSTN : in std_logic;                                       Active low reset input of the counter
		  LDN : in std_logic;--_vector(3 downto 0);                       -- Load D to the counter if LDN is low
		  E : in std_logic;                                            -- Count if E is high, retain otherwise
		  D : in std_logic_vector(3 downto 0);                         -- Count to load when LDN is low
		  SEC_0 : inout std_logic_vector(6 downto 0);                  -- Output state of the counter
        SEC_1 : inout std_logic_vector(6 downto 0);
		  MIN_0 : inout std_logic_vector(6 downto 0);
		  MIN_1 : inout std_logic_vector(6 downto 0);
		  HRS_0 : inout std_logic_vector(6 downto 0);
		  HRS_1 : inout std_logic_vector(6 downto 0));

end DIGITAL_CLOCK;


architecture FUNCTIONALITY of DIGITAL_CLOCK is

  signal Q0, Q1, Q2, Q3, Q4, Q5 : std_logic_vector(3 downto 0);
  signal RSTN_1, RSTN_2, RSTN_3, RSTN_4, RSTN_5, F, G, H, I, J, K, E1, E2, E3, E4, E5 : std_logic;
  
begin

U0 : COUNTER_SYNCHRO port map(CLK, '1', '1', LDN, E, D, Q0);
U1 : BCD2SSD port map(Q0, SEC_0, G);


E1 <= Q0(3) and (not(Q0(2))) and (not(Q0(1))) and Q0(0);

RSTN_1 <= (Q1(3) or (NOT(Q1(2))) or (NOT(Q1(0))) or Q1(1)) OR (Q0(2) or (NOT(Q0(3))) or (NOT(Q0(0))) or Q0(1));
--RSTN_2 <= RSTN AND RSTN_1;
U4 : COUNTER_SYNCHRO port map(CLK, RSTN_1, '1', LDN, E1, D, Q1);
U5 : BCD2SSD port map(Q1, SEC_1, F);


E2 <= E1 and (not(Q1(3))) and Q1(2) and (not(Q1(1))) and Q1(0); 

RSTN_2 <= (Q2(2) or (NOT(Q2(3))) or (NOT(Q2(0))) or Q2(1)) OR RSTN_1; 
U7 : COUNTER_SYNCHRO port map(CLK, RSTN_2, '1', LDN, E2, D, Q2);
U8 : BCD2SSD port map(Q2, MIN_0, H);


E3 <= E1 and E2 and Q2(3) and (not(Q2(2))) and (not(Q2(1))) and Q2(0);

RSTN_3 <= (Q3(3) or (NOT(Q3(2))) or (NOT(Q3(0))) or Q3(1)) OR RSTN_2;
--RSTN_4 <= RSTN AND RSTN_3;
U13 : COUNTER_SYNCHRO port map(CLK, RSTN_3, '1', LDN, E3, D, Q3);
U14 : BCD2SSD port map(Q3, MIN_1, K);


E4 <= E3 and E2 and E1 and (not(Q3(3))) and Q3(2) and (not(Q3(1))) and Q3(0);

RSTN_4 <= (Q4(2) or (NOT(Q4(3))) or (NOT(Q4(0))) or Q4(1)) OR RSTN_3;
--RSTN_4 <= Q4(3) or (not(Q4(2))) or Q4(1) or Q4(0);  
U15 : COUNTER_SYNCHRO port map(CLK, RSTN_4, '1', LDN, E4, D, Q4);
U16 : BCD2SSD port map(Q4, HRS_0, I);


E5 <= E4 and E3 and E2 and E1 and Q4(3) and (not(Q4(2))) and (not(Q4(1))) and Q4(0);

RSTN_5 <= (Q5(3) or Q5(2) or (not(Q5(1))) or Q5(0)) OR RSTN_4;
U17 : COUNTER_SYNCHRO port map(CLK, RSTN_5, '1', LDN, E5, D, Q5);
U18 : BCD2SSD port map(Q5, HRS_1, J);

end FUNCTIONALITY;
