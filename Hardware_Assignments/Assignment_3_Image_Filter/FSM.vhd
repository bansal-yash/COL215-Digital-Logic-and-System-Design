LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FSM IS
    PORT (
        clk : IN STD_LOGIC;
        ker_addr_fsm : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        img_addr_fsm : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        cycle_fsm : OUT INTEGER;
        task_fsm : OUT INTEGER;
        rst_fsm : OUT STD_LOGIC;
        wr_fsm : OUT STD_LOGIC;
        ram_addr_fsm : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        hpos_fsm : IN INTEGER;
        cycle2_fsm : out INTEGER := 0;
        clk25_fsm : OUT STD_LOGIC;
        vpos_fsm : IN INTEGER);
END FSM;

ARCHITECTURE Machine OF FSM IS
    SIGNAL ker_addr : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL img_addr : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL count : INTEGER := 0;
    SIGNAL cycle : INTEGER := 0;
    SIGNAL task : INTEGER := 0;
    SIGNAL row, col : INTEGER := 0;
    SIGNAL rst : STD_LOGIC := '1';
    SIGNAL wr : STD_LOGIC := '0';
    SIGNAL ram_addr : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    signal cycle2 : integer := 0;
    SIGNAL clk25 : STD_LOGIC := '0';

BEGIN
    ker_addr_fsm <= ker_addr;
    img_addr_fsm <= img_addr;
    cycle_fsm <= cycle;
    task_fsm <= task;
    rst_fsm <= rst;
    wr_fsm <= wr;
    ram_addr_fsm <= ram_addr;
    cycle2_fsm <= cycle2;
    clk25_fsm <= clk25;

    PROCESS (clk)
    BEGIN

        IF rising_edge(clk) THEN
            IF (cycle2 = 0) THEN
                clk25 <= '1';
                cycle2 <= cycle2 + 1;
            ELSIF (cycle2 = 1) THEN
                cycle2 <= cycle2 + 1;
            ELSIF (cycle2 = 2) THEN
                clk25 <= '0';
                cycle2 <= cycle2 + 1;
            ELSE
                cycle2 <= 0;
            END IF;

            IF task = 0 THEN
                IF cycle < 9 THEN
                    ker_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(cycle, 4));
                    cycle <= cycle + 1;
                    count <= count + 1;
                ELSIF cycle = 9 THEN
                    cycle <= 0;
                    count <= 0;
                    task <= 1;
                END IF;

            ELSIF task = 1 THEN
                IF row = 0 THEN
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 12));
                            cycle <= 1;
                        ELSIF cycle = 1 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 12));
                            cycle <= 2;
                        ELSIF cycle = 2 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(64, 12));
                            cycle <= 3;
                        ELSIF cycle = 3 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(65, 12));
                            cycle <= 4;
                        ELSIF cycle = 4 THEN
                            rst <= '0';
                            cycle <= 5;
                        ELSIF cycle < 15 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            count <= count + 1;
                            col <= col + 1;
                            rst <= '1';
                        END IF;
                    ELSIF col = 63 THEN

                        IF cycle = 2 THEN
                            cycle <= 3;
                            rst <= '0';
                        ELSIF cycle < 13 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            count <= count + 1;
                            row <= 1;
                            col <= 0;
                            rst <= '1';
                        END IF;
                    ELSE
                        IF cycle = 0 THEN
                            cycle <= 1;
                        ELSIF cycle = 1 THEN
                            cycle <= 2;
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(col + 1, 12));
                        ELSIF cycle = 2 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(col + 65, 12));
                            cycle <= 3;
                        ELSIF cycle = 3 THEN
                            cycle <= 4;
                            rst <= '0';
                        ELSIF cycle < 14 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            count <= count + 1;
                            col <= col + 1;
                            rst <= '1';
                        END IF;
                    END IF;

                ELSIF row < 63 THEN
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            cycle <= 1;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row - 64, 12));
                        ELSIF cycle = 1 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row - 63, 12));
                            cycle <= 2;
                        ELSIF cycle = 2 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row, 12));
                            cycle <= 3;
                        ELSIF cycle = 3 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + 1, 12));
                            cycle <= 4;
                        ELSIF cycle = 4 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + 64, 12));
                            cycle <= 5;
                        ELSIF cycle = 5 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + 65, 12));
                            cycle <= 6;
                        ELSIF cycle = 6 THEN
                            cycle <= 7;
                            rst <= '0';
                        ELSIF cycle < 17 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            count <= count + 1;
                            col <= 1;
                            rst <= '1';
                        END IF;
                    ELSIF col < 63 THEN
                        IF cycle = 0 THEN
                            cycle <= cycle + 1;
                        ELSIF cycle = 1 THEN
                            cycle <= 2;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row - 63 + col, 12));
                        ELSIF cycle = 2 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + 1 + col, 12));
                            cycle <= 3;
                        ELSIF cycle = 3 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + col + 65, 12));
                            cycle <= 4;
                        ELSIF cycle = 4 THEN
                            cycle <= 5;
                            rst <= '0';
                        ELSIF cycle < 15 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= col + 1;
                            count <= count + 1;
                            rst <= '1';
                        END IF;
                    ELSE
                        IF cycle = 2 THEN
                            cycle <= 3;
                            rst <= '0';
                        ELSIF cycle < 13 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= 0;
                            row <= row + 1;
                            count <= count + 1;
                            rst <= '1';
                        END IF;
                    END IF;
                ELSE--row 63
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            cycle <= 1;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(3968, 12));
                        ELSIF cycle = 1 THEN
                            cycle <= 2;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(3969, 12));
                        ELSIF cycle = 2 THEN
                            cycle <= 3;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(4032, 12));
                        ELSIF cycle = 3 THEN
                            cycle <= 4;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(4033, 12));
                        ELSIF cycle = 4 THEN
                            cycle <= 5;
                            rst <= '0';
                        ELSIF cycle < 15 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= 1;
                            count <= count + 1;
                            rst <= '1';
                        END IF;
                    ELSIF col < 63 THEN
                        IF cycle = 0 THEN
                            cycle <= 1;
                        ELSIF cycle = 1 THEN
                            cycle <= 2;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(3969 + col, 12));
                        ELSIF cycle = 2 THEN
                            cycle <= 3;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(4033 + col, 12));
                        ELSIF cycle = 3 THEN
                            cycle <= 4;
                            rst <= '0';
                        ELSIF cycle < 14 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= col + 1;
                            count <= count + 1;
                            rst <= '1';
                        END IF;
                    ELSE
                        IF cycle = 2 THEN
                            cycle <= 3;
                            rst <= '0';
                        ELSIF cycle < 13 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= 0;
                            row <= 0;
                            count <= 0;
                            task <= 2;
                            rst <= '1';
                            wr <= '1';
                        END IF;
                    END IF;
                END IF;
            ELSIF task = 2 THEN
                ram_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + col, 12));
                IF row = 0 THEN
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 12));
                            cycle <= 1;
                        ELSIF cycle = 1 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 12));
                            cycle <= 2;
                        ELSIF cycle = 2 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(64, 12));
                            cycle <= 3;
                        ELSIF cycle = 3 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(65, 12));
                            cycle <= 4;
                        ELSIF cycle = 4 THEN
                            rst <= '0';
                            cycle <= 5;
                        ELSIF cycle < 18 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            count <= count + 1;
                            col <= col + 1;
                            rst <= '1';
                        END IF;
                    ELSIF col = 63 THEN

                        IF cycle = 2 THEN
                            cycle <= 3;
                            rst <= '0';
                        ELSIF cycle < 16 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            count <= count + 1;
                            row <= 1;
                            col <= 0;
                            rst <= '1';
                        END IF;
                    ELSE
                        IF cycle = 0 THEN
                            cycle <= 1;
                        ELSIF cycle = 1 THEN
                            cycle <= 2;
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(col + 1, 12));
                        ELSIF cycle = 2 THEN
                            img_addr <= STD_LOGIC_VECTOR(TO_UNSIGNED(col + 65, 12));
                            cycle <= 3;
                        ELSIF cycle = 3 THEN
                            cycle <= 4;
                            rst <= '0';
                        ELSIF cycle < 17 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            count <= count + 1;
                            col <= col + 1;
                            rst <= '1';
                        END IF;
                    END IF;

                ELSIF row < 63 THEN
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            cycle <= 1;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row - 64, 12));
                        ELSIF cycle = 1 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row - 63, 12));
                            cycle <= 2;
                        ELSIF cycle = 2 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row, 12));
                            cycle <= 3;
                        ELSIF cycle = 3 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + 1, 12));
                            cycle <= 4;
                        ELSIF cycle = 4 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + 64, 12));
                            cycle <= 5;
                        ELSIF cycle = 5 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + 65, 12));
                            cycle <= 6;
                        ELSIF cycle = 6 THEN
                            cycle <= 7;
                            rst <= '0';
                        ELSIF cycle < 20 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            count <= count + 1;
                            col <= 1;
                            rst <= '1';
                        END IF;
                    ELSIF col < 63 THEN
                        IF cycle = 0 THEN
                            cycle <= cycle + 1;
                        ELSIF cycle = 1 THEN
                            cycle <= 2;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row - 63 + col, 12));
                        ELSIF cycle = 2 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + 1 + col, 12));
                            cycle <= 3;
                        ELSIF cycle = 3 THEN
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(64 * row + col + 65, 12));
                            cycle <= 4;
                        ELSIF cycle = 4 THEN
                            cycle <= 5;
                            rst <= '0';
                        ELSIF cycle < 18 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= col + 1;
                            count <= count + 1;
                            rst <= '1';
                        END IF;
                    ELSE
                        IF cycle = 2 THEN
                            cycle <= 3;
                            rst <= '0';
                        ELSIF cycle < 16 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= 0;
                            row <= row + 1;
                            count <= count + 1;
                            rst <= '1';
                        END IF;
                    END IF;
                ELSE
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            cycle <= 1;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(3968, 12));
                        ELSIF cycle = 1 THEN
                            cycle <= 2;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(3969, 12));
                        ELSIF cycle = 2 THEN
                            cycle <= 3;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(4032, 12));
                        ELSIF cycle = 3 THEN
                            cycle <= 4;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(4033, 12));
                        ELSIF cycle = 4 THEN
                            cycle <= 5;
                            rst <= '0';
                        ELSIF cycle < 18 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= 1;
                            count <= count + 1;
                            rst <= '1';
                        END IF;
                    ELSIF col < 63 THEN
                        IF cycle = 0 THEN
                            cycle <= 1;
                        ELSIF cycle = 1 THEN
                            cycle <= 2;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(3969 + col, 12));
                        ELSIF cycle = 2 THEN
                            cycle <= 3;
                            img_addr <= STD_LOGIC_VECTOR(to_unsigned(4033 + col, 12));
                        ELSIF cycle = 3 THEN
                            cycle <= 4;
                            rst <= '0';
                        ELSIF cycle < 17 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= col + 1;
                            count <= count + 1;
                            rst <= '1';
                        END IF;
                    ELSE
                        IF cycle = 2 THEN
                            cycle <= 3;
                            rst <= '0';
                        ELSIF cycle < 17 THEN
                            cycle <= cycle + 1;
                        ELSE
                            cycle <= 0;
                            col <= 0;
                            row <= 0;
                            count <= 0;
                            task <= 3;
                            wr <= '0';
                            rst <= '1';
                            ram_addr <= STD_LOGIC_VECTOR(to_unsigned(0, 12));
                        END IF;
                    END IF;
                END IF;

            ELSE
                IF (cycle2 = 0) THEN
                    IF hpos_fsm >= 10 AND hpos_fsm <= 74 AND vpos_fsm >= 10 AND vpos_fsm <= 74 THEN
                        IF (hpos_fsm = 74 AND vpos_fsm = 74) THEN
                            count <= 0;
                            ram_addr <= STD_LOGIC_VECTOR(to_unsigned(0, 12));
                        ELSE
                            count <= count + 1;
                            ram_addr <= STD_LOGIC_VECTOR(to_unsigned(count + 1, 12));

                        END IF;

                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Machine;