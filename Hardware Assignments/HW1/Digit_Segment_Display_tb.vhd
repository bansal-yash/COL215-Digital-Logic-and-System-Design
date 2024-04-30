LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Digit_Segment_Display_tb IS
END Digit_Segment_Display_tb;

ARCHITECTURE tb OF Digit_Segment_Display_tb IS

    COMPONENT Digit_Segment_Display
        PORT (
            A : IN STD_LOGIC;
            B : IN STD_LOGIC;
            C : IN STD_LOGIC;
            D : IN STD_LOGIC;
            p : OUT STD_LOGIC;
            q : OUT STD_LOGIC;
            r : OUT STD_LOGIC;
            s : OUT STD_LOGIC;
            t : OUT STD_LOGIC;
            u : OUT STD_LOGIC;
            v : OUT STD_LOGIC;
            an0 : OUT STD_LOGIC;
            an1 : OUT STD_LOGIC;
            an2 : OUT STD_LOGIC;
            an3 : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL A, B, C, D : STD_LOGIC;
    SIGNAL p, q, r, s, t, u, v, an0, an1, an2, an3 : STD_LOGIC;

BEGIN

    UUT : Digit_Segment_Display PORT MAP(A => A, B => B, C => C, D => D, p => p, q => q, r => r, s => s, t => t, u => u, v => v, an0 => an0, an1 => an1, an2 => an2, an3 => an3);

    A <= '0', '1' AFTER 160 ns;
    B <= '0', '1' AFTER 80 ns, '0' AFTER 160 ns, '1' AFTER 240 ns;
    C <= '0', '1' AFTER 40 ns, '0' AFTER 80 ns, '1' AFTER 120 ns, '0' AFTER 160 ns, '1' AFTER 200 ns, '0' AFTER 240 ns, '1' AFTER 280 ns;
    D <= '0', '1' AFTER 20 ns, '0' AFTER 40 ns, '1' AFTER 60 ns, '0' AFTER 80 ns, '1' AFTER 100 ns, '0' AFTER 120 ns, '1' AFTER 140 ns, '0' AFTER 160 ns, '1' AFTER 180 ns, '0' AFTER 200 ns, '1' AFTER 220 ns, '0' AFTER 240 ns, '1' AFTER 260 ns, '0' AFTER 280 ns, '1' AFTER 300 ns;
    an0 <= '0';
    an1 <= '1';
    an2 <= '1';
    an3 <= '1';

END tb;