library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity comparador is
	generic(constant N: integer := 6);
	port(A,B: in std_logic_vector(N-1 downto 0);EQ: out std_logic);
end comparador;

architecture arch of comparador is
	begin
		EQ <= '1' when (A=B) else '0';
end arch;