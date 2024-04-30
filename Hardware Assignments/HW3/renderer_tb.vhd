LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY renderer_tb IS
END renderer_tb;

ARCHITECTURE Behavioral OF renderer_tb IS
    SIGNAL clk25 : STD_LOGIC := '0';
    SIGNAL hpos : INTEGER := 0;
    SIGNAL vpos : INTEGER := 0;
    SIGNAL videoon : STD_LOGIC := '0';
    SIGNAL hsync : STD_LOGIC := '0';
    SIGNAL vsync : STD_LOGIC := '0';
    CONSTANT hd : INTEGER := 639;
    CONSTANT hfp : INTEGER := 16;
    CONSTANT hsp : INTEGER := 96;
    CONSTANT hbp : INTEGER := 48;
    CONSTANT vd : INTEGER := 479;
    CONSTANT vfp : INTEGER := 10;
    CONSTANT vsp : INTEGER := 2;
    CONSTANT vbp : INTEGER := 33;
    SIGNAL clk : STD_LOGIC := '1';
    SIGNAL ker_addr : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL img_addr : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL count : INTEGER := 0;
    SIGNAL cycle : INTEGER := 0;
    SIGNAL task : INTEGER := 0;
    SIGNAL row, col : INTEGER := 0;
    SIGNAL rst : STD_LOGIC := '1';
    SIGNAL wr : STD_LOGIC := '0';
    SIGNAL ram_addr : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL max : INTEGER := - 2147483647;
    SIGNAL min : INTEGER := 2147483647;
    SIGNAL temp : INTEGER := 0;
    SIGNAL ans : INTEGER := 0;
    SIGNAL ker_out : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL img_out : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ram_out : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_in : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL k0, k1, k2, k3, k4, k5, k6, k7, k8, k, i0, i1, i2, i3, i4, i5, i6, i7, i8, i : INTEGER := 0;
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL r, g, b : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

    COMPONENT dist_mem_gen_0
        PORT (
            a : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;
    COMPONENT dist_mem_gen_1
        PORT (
            a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;
    COMPONENT dist_mem_gen_2
        PORT (
            a : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            clk : IN STD_LOGIC;
            we : IN STD_LOGIC;
            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;
    COMPONENT MAC
        PORT (
            clk : IN STD_LOGIC;
            k : IN INTEGER;
            i : IN INTEGER;
            ans : OUT INTEGER;
            rst : IN STD_LOGIC
        );
    END COMPONENT;
    COMPONENT FSM
        PORT (
            clk : IN STD_LOGIC;
            ker_addr_fsm : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            img_addr_fsm : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            count_fsm : OUT INTEGER;
            cycle_fsm : OUT INTEGER;
            task_fsm : OUT INTEGER;
            rst_fsm : OUT STD_LOGIC;
            wr_fsm : OUT STD_LOGIC;
            ram_addr_fsm : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            hpos_fsm : IN INTEGER;
            vpos_fsm : IN INTEGER);
    END COMPONENT;
BEGIN
    clk <= NOT clk AFTER 5 ns;

    image : dist_mem_gen_0 PORT MAP(
        a => img_addr,
        spo => img_out);

    kernel : dist_mem_gen_1 PORT MAP(
        a => ker_addr,
        spo => ker_out);

    ram : dist_mem_gen_2 PORT MAP(
        a => ram_addr,
        d => data_in,
        clk => clk,
        we => wr,
        spo => ram_out);

    macUnit : MAC PORT MAP(
        clk => clk,
        k => k,
        i => i,
        ans => ans,
        rst => rst
    );

    fsmUnit : FSM PORT MAP(
        clk => clk,
        ker_addr_fsm => ker_addr,
        img_addr_fsm => img_addr,
        count_fsm => count,
        cycle_fsm => cycle,
        task_fsm => task,
        rst_fsm => rst,
        wr_fsm => wr,
        ram_addr_fsm => ram_addr,
        hpos_fsm => hpos,
        vpos_fsm => vpos);

    clk_div : PROCESS (clk)
        VARIABLE cycle2 : INTEGER := 0;
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (cycle2 = 0) THEN
                clk25 <= '1';
                cycle2 := cycle2 + 1;
            ELSIF (cycle2 = 1) THEN
                cycle2 := cycle2 + 1;
            ELSIF (cycle2 = 2) THEN
                clk25 <= '0';
                cycle2 := cycle2 + 1;
            ELSE
                cycle2 := 0;
            END IF;
        END IF;
    END PROCESS;
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF task = 0 THEN
                IF cycle = 1 THEN
                    k0 <= to_integer(signed(ker_out));
                ELSIF cycle = 2 THEN
                    k1 <= to_integer(signed(ker_out));
                ELSIF cycle = 3 THEN
                    k2 <= to_integer(signed(ker_out));
                ELSIF cycle = 4 THEN
                    k3 <= to_integer(signed(ker_out));
                ELSIF cycle = 5 THEN
                    k4 <= to_integer(signed(ker_out));
                ELSIF cycle = 6 THEN
                    k5 <= to_integer(signed(ker_out));
                ELSIF cycle = 7 THEN
                    k6 <= to_integer(signed(ker_out));
                ELSIF cycle = 8 THEN
                    k7 <= to_integer(signed(ker_out));
                ELSIF cycle = 9 THEN
                    k8 <= to_integer(signed(ker_out));
                END IF;

            ELSIF task = 1 THEN
                IF row = 0 THEN
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            i0 <= 0;
                            i1 <= 0;
                            i2 <= 0;
                            i3 <= 0;
                            i6 <= 0;
                        ELSIF cycle = 1 THEN
                            i4 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 2 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i7 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 4 THEN
                            i8 <= to_integer(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 5 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 6 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 7 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 8 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 9 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 10 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 11 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 12 THEN
                            k <= k8;
                            i <= i8;

                        ELSIF cycle = 13 THEN
                        ELSIF cycle = 14 THEN
                            temp <= ans;

                        ELSE
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                            col <= 1;
                        END IF;
                    ELSIF col = 63 THEN
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= 0;
                            i5 <= 0;
                            i8 <= 0;
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 3 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 4 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 5 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 6 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 7 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 8 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 9 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 10 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 11 THEN
                        ELSIF cycle = 12 THEN
                            temp <= ans;
                        ELSE
                            row <= 1;
                            col <= 0;
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                        END IF;
                    ELSE
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= 0;
                            i5 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i8 <= TO_INTEGER(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 4 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 5 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 6 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 7 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 8 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 9 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 10 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 11 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 12 THEN

                        ELSIF cycle = 13 THEN
                            temp <= ans;
                        ELSE
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                            col <= col + 1;

                        END IF;
                    END IF;

                ELSIF row < 63 THEN
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            i0 <= 0;
                            i3 <= 0;
                            i6 <= 0;

                        ELSIF cycle = 1 THEN
                            i1 <= TO_INTEGER(unsigned(img_out));

                        ELSIF cycle = 2 THEN
                            i2 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i4 <= TO_INTEGER(unsigned(img_out));

                        ELSIF cycle = 4 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));

                        ELSIF cycle = 5 THEN
                            i7 <= TO_INTEGER(unsigned(img_out));

                        ELSIF cycle = 6 THEN
                            i8 <= TO_INTEGER(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 7 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 8 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 9 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 10 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 11 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 12 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 13 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 14 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 15 THEN
                        ELSIF cycle = 16 THEN
                            temp <= ans;
                        ELSE
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                            col <= 1;

                        END IF;
                    ELSIF col < 63 THEN
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 4 THEN
                            i8 <= TO_INTEGER(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 5 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 6 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 7 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 8 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 9 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 10 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 11 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 12 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 13 THEN
                        ELSIF cycle = 14 THEN
                            temp <= ans;
                        ELSE
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                            col <= col + 1;

                        END IF;
                    ELSE
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= 0;
                            i5 <= 0;
                            i8 <= 0;
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 3 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 4 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 5 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 6 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 7 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 8 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 9 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 10 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 11 THEN
                        ELSIF cycle = 12 THEN
                            temp <= ans;
                        ELSE
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                            col <= 0;
                            row <= row + 1;

                        END IF;
                    END IF;
                ELSE
                    IF col = 0 THEN
                        IF cycle = 0 THEN

                            i0 <= 0;
                            i3 <= 0;
                            i6 <= 0;
                            i7 <= 0;
                            i8 <= 0;

                        ELSIF cycle = 1 THEN
                            i1 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 2 THEN
                            i2 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i4 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 4 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 5 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 6 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 7 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 8 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 9 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 10 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 11 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 12 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 13 THEN
                        ELSIF cycle = 14 THEN
                            temp <= ans;
                        ELSE
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                            col <= 1;
                        END IF;
                    ELSIF col < 63 THEN
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));
                            i8 <= 0;
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 4 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 5 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 6 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 7 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 8 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 9 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 10 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 11 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 12 THEN
                        ELSIF cycle = 13 THEN
                            temp <= ans;
                        ELSE
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                            col <= col + 1;
                        END IF;
                    ELSE
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= 0;
                            i5 <= 0;
                            i8 <= 0;
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 3 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 4 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 5 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 6 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 7 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 8 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 9 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 10 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 11 THEN
                        ELSIF cycle = 12 THEN
                            temp <= ans;
                        ELSE
                            IF temp > max THEN
                                max <= temp;
                            END IF;
                            IF temp < min THEN
                                min <= temp;
                            END IF;
                            col <= 0;
                            row <= 0;
                        END IF;
                    END IF;
                END IF;

            ELSIF task = 2 THEN
                IF row = 0 THEN
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            i0 <= 0;
                            i1 <= 0;
                            i2 <= 0;
                            i3 <= 0;
                            i6 <= 0;
                        ELSIF cycle = 1 THEN
                            i4 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 2 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i7 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 4 THEN
                            i8 <= to_integer(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 5 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 6 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 7 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 8 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 9 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 10 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 11 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 12 THEN
                            k <= k8;
                            i <= i8;

                        ELSIF cycle = 13 THEN
                        ELSIF cycle = 14 THEN
                            temp <= ans;

                        ELSIF cycle = 15 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 16 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 17 THEN
                        ELSE
                            col <= 1;
                        END IF;

                    ELSIF col = 63 THEN

                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= 0;
                            i5 <= 0;
                            i8 <= 0;
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 3 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 4 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 5 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 6 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 7 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 8 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 9 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 10 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 11 THEN
                        ELSIF cycle = 12 THEN
                            temp <= ans;
                        ELSIF cycle = 13 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 14 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 15 THEN
                        ELSE
                            col <= 0;
                            row <= 1;
                        END IF;
                    ELSE
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= 0;
                            i5 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i8 <= TO_INTEGER(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 4 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 5 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 6 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 7 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 8 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 9 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 10 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 11 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 12 THEN

                        ELSIF cycle = 13 THEN
                            temp <= ans;
                        ELSIF cycle = 14 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 15 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 16 THEN
                        ELSE
                            col <= col + 1;
                        END IF;
                    END IF;

                ELSIF row < 63 THEN
                    IF col = 0 THEN
                        IF cycle = 0 THEN
                            i0 <= 0;
                            i3 <= 0;
                            i6 <= 0;

                        ELSIF cycle = 1 THEN
                            i1 <= TO_INTEGER(unsigned(img_out));

                        ELSIF cycle = 2 THEN
                            i2 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i4 <= TO_INTEGER(unsigned(img_out));

                        ELSIF cycle = 4 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));

                        ELSIF cycle = 5 THEN
                            i7 <= TO_INTEGER(unsigned(img_out));

                        ELSIF cycle = 6 THEN
                            i8 <= TO_INTEGER(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 7 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 8 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 9 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 10 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 11 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 12 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 13 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 14 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 15 THEN
                        ELSIF cycle = 16 THEN
                            temp <= ans;
                        ELSIF cycle = 17 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 18 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 19 THEN
                        ELSE
                            col <= 1;
                        END IF;
                    ELSIF col < 63 THEN
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 4 THEN
                            i8 <= TO_INTEGER(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 5 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 6 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 7 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 8 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 9 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 10 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 11 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 12 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 13 THEN
                        ELSIF cycle = 14 THEN
                            temp <= ans;
                        ELSIF cycle = 15 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 16 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 17 THEN
                        ELSE
                            col <= col + 1;
                        END IF;
                    ELSE
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= 0;
                            i5 <= 0;
                            i8 <= 0;
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 3 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 4 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 5 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 6 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 7 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 8 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 9 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 10 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 11 THEN
                        ELSIF cycle = 12 THEN
                            temp <= ans;
                        ELSIF cycle = 13 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 14 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 15 THEN
                        ELSE
                            col <= 0;
                            row <= row + 1;
                        END IF;
                    END IF;
                ELSE
                    IF col = 0 THEN
                        IF cycle = 0 THEN

                            i0 <= 0;
                            i3 <= 0;
                            i6 <= 0;
                            i7 <= 0;
                            i8 <= 0;

                        ELSIF cycle = 1 THEN
                            i1 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 2 THEN
                            i2 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i4 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 4 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 5 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 6 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 7 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 8 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 9 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 10 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 11 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 12 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 13 THEN
                        ELSIF cycle = 14 THEN
                            temp <= ans;
                        ELSIF cycle = 15 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 16 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 17 THEN
                        ELSE
                            col <= 1;
                        END IF;
                    ELSIF col < 63 THEN
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= TO_INTEGER(unsigned(img_out));
                        ELSIF cycle = 3 THEN
                            i5 <= TO_INTEGER(unsigned(img_out));
                            i8 <= 0;
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 4 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 5 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 6 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 7 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 8 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 9 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 10 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 11 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 12 THEN
                        ELSIF cycle = 13 THEN
                            temp <= ans;
                        ELSIF cycle = 14 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 15 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 16 THEN
                        ELSE
                            col <= col + 1;
                        END IF;
                    ELSE
                        IF cycle = 0 THEN
                            i0 <= i1;
                            i3 <= i4;
                            i6 <= i7;
                        ELSIF cycle = 1 THEN
                            i1 <= i2;
                            i4 <= i5;
                            i7 <= i8;
                        ELSIF cycle = 2 THEN
                            i2 <= 0;
                            i5 <= 0;
                            i8 <= 0;
                            k <= k0;
                            i <= i0;
                        ELSIF cycle = 3 THEN
                            k <= k1;
                            i <= i1;
                        ELSIF cycle = 4 THEN
                            k <= k2;
                            i <= i2;
                        ELSIF cycle = 5 THEN
                            k <= k3;
                            i <= i3;
                        ELSIF cycle = 6 THEN
                            k <= k4;
                            i <= i4;
                        ELSIF cycle = 7 THEN
                            k <= k5;
                            i <= i5;
                        ELSIF cycle = 8 THEN
                            k <= k6;
                            i <= i6;
                        ELSIF cycle = 9 THEN
                            k <= k7;
                            i <= i7;
                        ELSIF cycle = 10 THEN
                            k <= k8;
                            i <= i8;
                        ELSIF cycle = 11 THEN
                        ELSIF cycle = 12 THEN
                            temp <= ans;
                        ELSIF cycle = 13 THEN
                            temp <= ((255 * (temp - min)) / (max - min));

                        ELSIF cycle = 14 THEN
                            data_in <= STD_LOGIC_VECTOR(to_unsigned(temp, 8));
                        ELSIF cycle = 15 THEN
                        ELSIF cycle = 16 THEN
                        ELSE
                            col <= 0;
                            row <= 0;
                        END IF;
                    END IF;
                END IF;

            ELSE

            END IF;
        END IF;
    END PROCESS;

    horizontal_position_counter : PROCESS (clk25, reset)
    BEGIN
        IF (reset = '1') THEN
            hpos <= 0;
        ELSIF (clk25'event AND clk25 = '1') THEN
            IF (hpos = hd + hfp + hsp + hbp) THEN
                hpos <= 0;
            ELSE
                hpos <= hpos + 1;
            END IF;
        END IF;
    END PROCESS;

    vertical_position_counter : PROCESS (clk25, reset, hpos)
    BEGIN
        IF (reset = '1') THEN
            vpos <= 0;
        ELSIF (clk25'event AND clk25 = '1') THEN
            IF (hpos = hd + hfp + hsp + hbp) THEN
                IF (vpos = vd + vfp + vsp + vbp) THEN
                    vpos <= 0;
                ELSE
                    vpos <= vpos + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    horizontal_synchronisation : PROCESS (clk25, reset, hpos)
    BEGIN
        IF (reset = '1') THEN
            hsync <= '0';
        ELSIF (clk25'event AND clk25 = '1') THEN
            IF (hpos <= (hd + hfp) OR hpos > (hd + hfp + hsp)) THEN
                hsync <= '1';
            ELSE
                hsync <= '0';
            END IF;
        END IF;
    END PROCESS;

    vertical_synchronisation : PROCESS (clk25, reset, vpos)
    BEGIN
        IF (reset = '1') THEN
            vsync <= '0';
        ELSIF (clk25'event AND clk25 = '1') THEN
            IF (vpos <= (vd + vfp) OR vpos > (vd + vfp + vsp)) THEN
                vsync <= '1';
            ELSE
                vsync <= '0';
            END IF;
        END IF;
    END PROCESS;

    video_on : PROCESS (clk25, reset, hpos, vpos)
    BEGIN
        IF (reset = '1') THEN
            videoon <= '0';
        ELSIF (clk25'event AND clk25 = '1') THEN
            IF (hpos <= hd AND vpos <= vd) THEN
                videoon <= '1';
            ELSE
                videoon <= '0';
            END IF;
        END IF;
    END PROCESS;
    draw : PROCESS (clk25, reset, hPos, vPos, videoOn)
    BEGIN

        IF rising_edge(clk25) THEN
            IF task = 3 THEN
                IF (reset = '1') THEN
                    R <= "0000";
                    G <= "0000";
                    B <= "0000";
                ELSIF (videoon = '1') THEN
                    IF ((hpos >= 10 AND hpos <= 73) AND (vpos >= 10 AND vpos <= 73)) THEN
                        r(3) <= ram_out(7);
                        g(3) <= ram_out(7);
                        b(3) <= ram_out(7);
                        r(2) <= ram_out(6);
                        g(2) <= ram_out(6);
                        b(2) <= ram_out(6);
                        r(1) <= ram_out(5);
                        g(1) <= ram_out(5);
                        b(1) <= ram_out(5);
                        r(0) <= ram_out(4);
                        g(0) <= ram_out(4);
                        b(0) <= ram_out(4);

                    ELSE
                        R <= "0000";
                        G <= "0000";
                        B <= "0000";
                    END IF;
                ELSE
                    R <= "0000";
                    G <= "0000";
                    B <= "0000";
                END IF;
            ELSE
                R <= "0000";
                G <= "0000";
                B <= "0000";
            END IF;

        END IF;
    END PROCESS;

END Behavioral;