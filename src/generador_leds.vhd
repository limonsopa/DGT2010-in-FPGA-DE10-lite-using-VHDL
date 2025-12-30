library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generador_leds is
	generic(constant M: integer := 10);--configurar M para que de señal de 1 Hz de manera que : M*2 = 1/frecuencia de clk_in
	port(reset,clk,min_value_j0,min_value_j1: in std_logic;leds: out std_logic_vector(9 downto 0));
end generador_leds;

architecture arch of generador_leds is
	signal clk_reg: std_logic;
	signal cuenta: integer;
	begin
--==================================================================================
--------------------- Parte Combinacional ------------------------------------------
--==================================================================================

		process(reset,clk)
			begin
				if reset = '0' then
					clk_reg <= '0';
					cuenta <= 0;
				elsif rising_edge(clk) then
					if cuenta = M-1 then
						cuenta <= 0;
						clk_reg <= not(clk_reg);
					else
						cuenta <= cuenta +1;
					end if;
				end if;
		end process;
--===================================================================================
---------------------- Generación de los patrones -----------------------------------
--===================================================================================
		process(cuenta,min_value_j0,min_value_j1)
			begin
--=================== Jugador 0 pierde =================================================
				if min_value_j0 ='1' then
					if clk_reg = '0' then
						leds <= "1010100000";
					else
						leds <= "0101000000";
					end if;
--=================== Jugador 1 pierde =================================================
				elsif min_value_j1 = '1' then
					if clk_reg = '0' then
						leds <= "0000010101";
					else
						leds <= "0000001010";
					end if;
				end if;
		end process;
end arch;