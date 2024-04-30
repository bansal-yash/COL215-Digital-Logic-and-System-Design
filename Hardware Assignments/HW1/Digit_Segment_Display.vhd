LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Digit_Segment_Display IS
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
END Digit_Segment_Display;

ARCHITECTURE Behavioral OF Digit_Segment_Display IS

BEGIN

    p <= NOT((A AND (NOT B) AND (NOT C)) OR ((NOT A) AND B AND D) OR (A AND (NOT D)) OR ((NOT A) AND C) OR (B AND C) OR ((NOT B) AND (NOT D)));
    q <= NOT(((NOT A) AND (NOT C) AND (NOT D)) OR ((NOT A)AND C AND D) OR (A AND(NOT C) AND D) OR ((NOT B) AND (NOT C)) OR((NOT B) AND (NOT D)));
    r <= NOT(((NOT A) AND (NOT C)) OR ((NOT A) AND D) OR((NOT C) AND D) OR ((NOT A)AND B) OR(A AND (NOT B)));
    t <= NOT(((NOT B) AND (NOT D)) OR (C AND(NOT D)) OR (A AND C) OR (A AND B));
    s <= NOT(((NOT A) AND (NOT B) AND (NOT D)) OR((NOT B) AND C AND D) OR (B AND (NOT C) AND D) OR (B AND C AND(NOT D)) OR (A AND (NOT C)));
    u <= NOT(((NOT A)AND B AND (NOT C)) OR ((NOT C) AND (NOT D)) OR(B AND (NOT D)) OR(A AND (NOT B)) OR(A AND C));
    v <= NOT(((NOT A) AND B AND (NOT C)) OR ((NOT B) AND C) OR(C AND (NOT D)) OR(A AND (NOT B)) OR (A AND D));
    an0 <= '0';
    an1 <= '1';
    an2 <= '1';
    an3 <= '1';

END Behavioral;