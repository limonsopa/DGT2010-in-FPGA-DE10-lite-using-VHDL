library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux4a1 is
	port(a00,a01,a10,a11: in std_logic_vector(6 downto 0);
							sel: in std_logic_vector(1 downto 0);
							f: out std_logic_vector(6 downto 0));
end Mux4a1;

architecture arch of Mux4a1 is
	begin
		f <= a00 when (sel = "00") else
				a01 when (sel ="01") else
				a10 when (sel = "10") else
				a11 when (sel = "11") else
				(others=>'-');
end arch;