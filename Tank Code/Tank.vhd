library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- Untuk tipe data STD_LOGIC dan STD_LOGIC_VECTOR
use IEEE.STD_LOGIC_ARITH.ALL; -- Untuk operasi aritmatika
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- Untuk operasi pembanding angka

entity Tank is
    Port ( 
        -- Inputs
        level : in STD_LOGIC_VECTOR(1 downto 0);  -- 2-bit input untuk level air (00 = low, 01 = normal, 11 = high)
        temp_input : in STD_LOGIC_VECTOR(6 downto 0); -- Suhu air (7-bit)
        pump_state : in STD_LOGIC;  -- Status pompa (dari kode pompa)
        clock : in STD_LOGIC;       -- Clock signal (untuk kontrol waktu)

        -- Outputs
        level_tank : out STD_LOGIC_VECTOR(1 downto 0); -- Menunjukkan level air
        alarm : out STD_LOGIC;       -- Alarm (1 = menyala, 0 = mati)
        temp : out STD_LOGIC_VECTOR(6 downto 0)        -- Output suhu air (7-bit)
    );
end Tank;

architecture behavioral of Tank is
    -- Internal signals
    signal current_level : STD_LOGIC_VECTOR(1 downto 0) := "00";  -- Default: LOW level
    signal alarm_timer : INTEGER range 0 to 5 := 0;  -- Timer untuk alarm (5 detik)
begin
    -- Process untuk menangani level air, suhu dan alarm
    process(clock)
    begin
        if rising_edge(clock) then
            -- Update suhu (direct output dari temp_input)
            temp <= temp_input;

            -- Perbandingan level air dan kontrol alarm
            case level is
                when "00" =>  -- LOW level
                    current_level <= "00";  -- Set current level ke LOW
                    -- Jika level air rendah, aktifkan timer
                    if alarm_timer < 5 then
                        alarm_timer <= alarm_timer + 1;
                        alarm <= '0';  -- Alarm mati selama timer belum mencapai 5 detik
                    else
                        alarm <= '1';  -- Alarm menyala setelah 5 detik
                    end if;
                when "01" =>  -- NORMAL level
                    current_level <= "01";  -- Set current level ke NORMAL
                    alarm_timer <= 0;  -- Reset timer
                    alarm <= '0';  -- Reset alarm
                when "11" =>  -- HIGH level
                    current_level <= "11";  -- Set current level ke HIGH
                    alarm_timer <= 0;  -- Reset timer
                    alarm <= '0';  -- Reset alarm
                when others =>
                    -- Jika nilai level tidak valid, tetap di level rendah
                    current_level <= "00"; 
            end case;

            -- Output level_tank sesuai status current_level
            level_tank <= current_level;

        end if;
    end process;

end behavioral;