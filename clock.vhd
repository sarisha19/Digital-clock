library IEEE;
use IEEE.std_logic_1164.all;
use work.EE232.all;

entity DIGITAL_CLOCK is                                              -- Entity declaration
	
	port(CLK : in std_logic;                                          -- Clock input of the counter
		  SET : in std_logic;                                          -- Active low reset input of the counter
		  --UP_DN : in std_logic;                                        -- Count up if UP_DN is high, down if low
		  SW : in std_logic;
		  LDN : in std_logic_vector(2 downto 0);                       -- Load D to the counter if LDN is low
		  E : in std_logic;                                            -- Count if E is high, retain otherwise
		  D : in std_logic_vector(3 downto 0);                         -- Count to load when LDN is low
		  UNI_0 : out std_logic_vector(6 downto 0);                    -- Output state of the counter
        UNI_1 : out std_logic_vector(6 downto 0);
		  TEN_0 : out std_logic_vector(6 downto 0);
		  TEN_1 : out std_logic_vector(6 downto 0);
		  HUN_0 : out std_logic_vector(6 downto 0);
		  HUN_1 : out std_logic_vector(6 downto 0));              --63ns and 3600ns and 8640ns

end DIGITAL_CLOCK;


architecture FUNCTIONALITY of DIGITAL_CLOCK is

  signal MS0, MS1, S0, S1, M0, M1, H0, H1, UN0, UN1, TN0, TN1, HN0, HN1 : std_logic_vector(3 downto 0);
  signal RSTN, RSTN_m0, RSTN_m1, RSTN_0, RSTN_1, RSTN_2, RSTN_3, RSTN_4, RSTN_5, F, G, H, O, J, K : std_logic;
  signal E0, ES, E1, E2, E3, E4, E5, LS_0, LS_1, LM_0, LM_1, LH_0, LH_1 : std_logic;
  
begin

--U: CLK_DVD port map(CLK_in, RSTN, CLK);

RSTN <= (not(LDN(2))) or (not(LDN(1))) or (not(LDN(0))) or (not(SET));  --given rstn using LDN and SET button.

RSTN_m0 <= (MS0(2) or (NOT(MS0(3))) or (NOT(MS0(0))) or MS0(1)) AND (RSTN);  --RSTN for MSEC_0.

A0 : COUNTER_SYNCHRO port map(CLK, RSTN_m0, '1', '1', E, D, MS0);


E0 <= MS0(3) and (not(MS0(2))) and (not(MS0(1))) and MS0(0); --enable signal for MSEC_1;

RSTN_m1 <= (MS1(2) or (NOT(MS1(3))) or (NOT(MS1(0))) or MS1(1) OR (RSTN_m0)) AND (RSTN);

A2 : COUNTER_SYNCHRO port map(CLK, RSTN_m1, '1', '1', E0, D, MS1);


 UNIT_BANK:
  
  for i in 0 to 3 generate
  
    A4 : MUX_2X1 port map(S0(i), MS0(i), SW, UN0(i));
	 A5 : MUX_2X1 port map(S1(i), MS1(i), SW, UN1(i));
	 
  end generate;
  
U1 : BCD2SSD port map(UN0, UNI_0, F);
U5 : BCD2SSD port map(UN1, UNI_1, G);

ES <= E0 and ((not(MS1(2))) and MS1(3) and (not(MS1(1))) and MS1(0));  --enable signal for sec_0 (enables when _:_:_:99 and retains when low)


RSTN_0 <= ((S0(2) or (NOT(S0(3))) or (NOT(S0(0))) or S0(1)) OR (RSTN_m1)) AND (RSTN);  --RSTN for SEC_0.
 
LS_0 <= (LDN(2) or LDN(1) or (NOT(LDN(0)))) or (NOT(SET));  --LDN signal for SEC_0 (load is given at 001)
U0 : COUNTER_SYNCHRO port map(CLK, RSTN_0, '1', LS_0, ES, D, S0);


E1 <= ES and (S0(3) and (not(S0(2))) and (not(S0(1))) and S0(0));  --enable signal for sec_1 (enables when _:_:_9:99 and retains when low)


RSTN_1 <= (S1(3) or (NOT(S1(2))) or (NOT(S1(0))) or S1(1) OR RSTN_0) AND (RSTN);  --rstn signal for sec_1 (resets when low)

LS_1 <= (LDN(2) or LDN(0) or (NOT(LDN(1)))) or (NOT(SET)); --LDN signal for SEC_1 (load is given at 010)
U4 : COUNTER_SYNCHRO port map(CLK, RSTN_1, '1', LS_1, E1, D, S1);


 TEN_BANK:
  
  for i in 0 to 3 generate
  
    A1 : MUX_2X1 port map(M0(i), S0(i), SW, TN0(i));
	 A3 : MUX_2X1 port map(M1(i), S1(i), SW, TN1(i));
	 
  end generate;
  
U8 : BCD2SSD port map(TN0, TEN_0, H);
U14 : BCD2SSD port map(TN1, TEN_1, K);

E2 <= E1 and ((not(S1(3))) and S1(2) and (not(S1(1))) and S1(0));  --enable signal for min_0 (enables when _:_:59 and retains when low)


RSTN_2 <= (M0(2) or (NOT(M0(3))) or (not(M0(0))) or M0(1) OR RSTN_1) AND (RSTN); --rstn signal for min_0 (resets when low)

LM_0 <= (LDN(2) or (NOT(LDN(1))) or (NOT(LDN(0)))) or (NOT(SET));  --LDN signal for MIN_0 (load is given at 011)
U7 : COUNTER_SYNCHRO port map(CLK, RSTN_2, '1', LM_0, E2, D, M0);


E3 <= E2 and M0(3) and (not(M0(2))) and (not(M0(1))) and M0(0);  --enable signal for min_1 (enables when _:_9:59 and retains when low)

RSTN_3 <= (M1(3) or (NOT(M1(2))) or (NOT(M1(0))) or M1(1) OR RSTN_2) AND (RSTN);  --rstn signal for min_1 (resets when low)
LM_1 <= (LDN(0) or LDN(1) or (NOT(LDN(2)))) or (NOT(SET));  --LDN signal for MIN_1 (load is given at 100)
U13 : COUNTER_SYNCHRO port map(CLK, RSTN_3, '1', LM_1, E3, D, M1);


 HUN_BANK:
  
  for i in 0 to 3 generate
  
    A1 : MUX_2X1 port map(H0(i), M0(i), SW, HN0(i));
	 A3 : MUX_2X1 port map(H1(i), M1(i), SW, HN1(i));
	 
  end generate;
  
U16 : BCD2SSD port map(HN0, HUN_0, O);
U18 : BCD2SSD port map(HN1, HUN_1, J);

E4 <= E3 and (not(M1(3))) and M1(2) and (not(M1(1))) and M1(0);  --enable signal for hrs_0 (enables when _:59:59 and retains when low)

RSTN_4 <= (((H0(1) or (NOT(H0(3))) or (NOT(H0(0))) or H0(2)) OR (RSTN_3)) AND (RSTN_5)) AND (RSTN);  --rstn signal for hrs_0 (resets when low) 
LH_0 <= (LDN(1) or (NOT(LDN(2))) or (NOT(LDN(0)))) or (NOT(SET));  --LDN signal for HRS_0 (load is given at 101) 
U15 : COUNTER_SYNCHRO port map(CLK, RSTN_4, '1', LH_0, E4, D, H0);


E5 <= E4 and H0(3) and (not(H0(2))) and (not(H0(1))) and H0(0);  --enable signal for hrs_1 (enables when _9:59:59 and retains when low)

RSTN_5 <= ((H1(3) or H1(2) or (not(H1(1))) or H1(0)) OR (H0(3) or (NOT(H0(1))) or (NOT(H0(0))) or H0(2)) OR (RSTN_3)) AND (RSTN);  --rstn signal for hrs_1 (resets when low)
LH_1 <= (LDN(0) or (NOT(LDN(1))) or (NOT(LDN(2)))) or (NOT(SET));  --LDN signal for HRS_1 (load is given at 110)
U17 : COUNTER_SYNCHRO port map(CLK, RSTN_5, '1', LH_1, E5, D, H1);

end FUNCTIONALITY;
