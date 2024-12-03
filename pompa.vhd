library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pompa is
    port (
        signal clk : in std_logic;
        signal alarm : out std_logic;
        signal pompa : inout std_logic;
        signal tank_state : in std_logic_vector(1 downto 0); --tracking state tangki
        signal luas_pompa : in std_logic_vector(2 downto 0);
        signal kecepatan_air : in std_logic_vector(2 downto 0); --sementara 3 bit
        signal delivery_head : in std_logic_vector(2 downto 0); --sementara 3 bit
        signal efisiensi : out std_logic_vector(5 downto 0); --sementara 5 bit
        signal debit : out std_logic_vector(5 downto 0); --sementara 5 bit
    );
end entity pompa;

architecture Behavioral of pompa is
    -- variable" disini buat rumus
    -- daya dan densitas di sini?
begin
    
end architecture Behavioral;