LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pompa IS
    PORT (
        SIGNAL clk : IN STD_LOGIC;
        SIGNAL alarm_pompa : IN STD_LOGIC;
        SIGNAL enable_pompa : INOUT STD_LOGIC;
        SIGNAL pump_state : OUT STD_LOGIC; --tracking state pump, buat tim Tangki silakan output ini jadi input buat tangki
        SIGNAL luas_pompa : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL kecepatan_air : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --sementara 3 bit
        SIGNAL delivery_head : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --sementara 3 bit
        SIGNAL efisiensi : OUT STD_LOGIC_VECTOR(19 DOWNTO 0); --sementara 5 bit
        SIGNAL debit : OUT STD_LOGIC_VECTOR(5 DOWNTO 0); --sementara 5 bit
        SIGNAL kegiatan_pompa : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0) --sementara 2 bit
    );
END ENTITY pompa;

ARCHITECTURE Behavioral OF pompa IS
    -- variable" disini buat rumus
    -- daya dan densitas di sini?
    SIGNAL daya : unsigned(10 DOWNTO 0) := "11111010000"; -- 2000 Watt
    SIGNAL densitas : unsigned(10 DOWNTO 0) := "01111101000"; -- 1000 kg/m^3
    SIGNAL faktor_pembagi : UNSIGNED(8 DOWNTO 0) := "101101001"; -- 367
    TYPE StateType IS (MENGISI, GABUT);
    SIGNAL current_state : StateType := GABUT;

    FUNCTION calculate_debit(luas_pompa : STD_LOGIC_VECTOR(2 DOWNTO 0); kecepatan_air : STD_LOGIC_VECTOR(2 DOWNTO 0)) RETURN unsigned IS
        VARIABLE internal_debit : unsigned(5 DOWNTO 0);
    BEGIN
        internal_debit := unsigned(luas_pompa) * unsigned(kecepatan_air);
        RETURN internal_debit;
    END FUNCTION;

    FUNCTION calculate_efisiensi(internal_debit : unsigned; delivery_head : STD_LOGIC_VECTOR(2 DOWNTO 0); densitas : unsigned; daya : unsigned) RETURN unsigned IS
        VARIABLE efisiensi_temp : INTEGER;
        VARIABLE koma : INTEGER;
        VARIABLE result : unsigned(19 DOWNTO 0);
    BEGIN
        efisiensi_temp := to_integer((internal_debit * unsigned(delivery_head) * densitas * 10000) / (367 * daya)); -- scale by 1000
        koma := efisiensi_temp MOD 100;

        IF koma > 50 THEN
            efisiensi_temp := efisiensi_temp + 100;
        END IF;

        efisiensi_temp := efisiensi_temp / 100;
        result := to_unsigned(efisiensi_temp, 20);
        RETURN result;
    END FUNCTION;

BEGIN
    PROCESS (clk, kecepatan_air, luas_pompa, delivery_head)
        VARIABLE internal_debit : unsigned(5 DOWNTO 0);
    BEGIN
        IF falling_edge(clk) THEN
            IF enable_pompa = '1' THEN
                IF current_state = MENGISI THEN
                    pump_state <= '1';
                    kegiatan_pompa <= "01";
                    IF alarm_pompa = '0' THEN
                        current_state <= GABUT;
                    END IF;
                ELSIF current_state = GABUT THEN
                    pump_state <= '0';
                    kegiatan_pompa <= "00";
                    IF alarm_pompa = '1' THEN
                        current_state <= MENGISI;
                    END IF;
                END IF;
            ELSIF enable_pompa = '0' THEN
                REPORT "Pompa mati! Hidupkan dulu bos" SEVERITY warning;
                current_state <= GABUT;
            END IF;

            internal_debit := calculate_debit(luas_pompa, kecepatan_air);
            efisiensi <= STD_LOGIC_VECTOR(calculate_efisiensi(internal_debit, delivery_head, densitas, daya));
            debit <= STD_LOGIC_VECTOR(internal_debit);
        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;