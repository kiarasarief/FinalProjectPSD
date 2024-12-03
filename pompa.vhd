library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pompa is
    port (
        signal clk : in std_logic;
        signal alarm : out std_logic;
        signal pompa : inout std_logic;
        signal tank_state : in std_logic_vector(1 downto 0);
        signal luas_pompa : in integer;
    );
end entity pompa;

architecture Behavioral of pompa is
    -- variable" disini buat rumus
begin
    
end architecture Behavioral;