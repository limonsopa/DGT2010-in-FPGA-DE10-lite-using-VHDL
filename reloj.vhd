library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.my_components.all;

entity reloj is
	port(reset_n,clk,ini_pausa,borrar: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			mov_restricciones: in std_logic; --señal que se activa para cuando los movimientos sean 40+16*k porque ahi se van añadiendo 1 hora adicional en wccs
			display_0,display_1,display_2,display_3,display_4,display_5: out std_logic_vector(6 downto 0);
			min_value: out std_logic);
end reloj;

architecture arch of reloj is
	signal clk_en,g_reset_n,en_seg,en_min,en_hr,min_seg,min_min,min_hr: std_logic;
	signal min: std_logic_vector(5 downto 0);
	signal seg: std_logic_vector(5 downto 0);
	signal hr: std_logic_vector(1 downto 0);
	signal seg_decimal,min_decimal,hr_decimal: std_logic_vector(7 downto 0);
	signal ceros_hr: std_logic_vector(5 downto 0);
	signal tiempo_inicial: std_logic_vector(13 downto 0);--tiempo en formato hr(2):min(6):seg(6)
	signal mov_restricciones_wccm: std_logic;
	begin
	
		g_reset_n <= reset_n and (ini_pausa or not(borrar));
		
		div_freq: divisor_freq generic map(N=>10,BUS_WIDTH=>4) port map(reset_n=>reset_n,clk=>clk,clk_o=>clk_en);
--==========================================================================================================================================
--====================================== Habilitaciones para los contadores ==============================================================================
--==========================================================================================================================================
		
		en_seg <= clk_en and ini_pausa;
		en_min <= en_seg and min_seg;
		en_hr <= en_min and min_min;
		min_value <= min_hr and min_min and min_seg;
--==========================================================================================================================================
--====================================== SELECTOR DE MODOS DE JUEGO ==============================================================================
--==========================================================================================================================================
		
		modo: selector_modo generic map(A=>1,BC=>57,DE=>20) port map(sel=>sel,tiempo=>tiempo_inicial);
		--Aqui seleccionamos en en generic map los numeros segun queramos para el modo manual, claro
		--cabe recalcar que solo valdran si seleccionamos el modo manual sel=11
		
		--NOTA--
		--SOLO en el modo WCCM se habilitirá el efecto de añadir 1 hora cada 40 +16*k +1 movimientos onde k= 1,2,3,4... etc 
		--entonces el efecto de la señal mov_restricciones solo funcionará en ese caso, por lo tanto
		--solo deberá activarse cuando sel = 10, por lo cual:
		mov_restricciones_wccm <= (mov_restricciones and sel(1)) and not (sel(0));
--==========================================================================================================================================
--====================================== LOGICA PARA LOS CONTADORES ==============================================================================
--==========================================================================================================================================

--======================================= HORAS =============================================================================================
		counter_hr: counter_horas generic map(M=>3,N=>2) port map(g_reset_n=>g_reset_n,valor_inicial=>tiempo_inicial(13 downto 12),
																					en=>en_hr,clk=>clk,mov_restricciones=>mov_restricciones_wccm,q=>hr);
		comparador_0_hr: comparador generic map(N=>2) port map(A=>hr,B=>"00",EQ=>min_hr);
		ceros_hr <= "0000" & hr;
		bintobcd_hr: bintobcd port map(a=>ceros_hr,f=>hr_decimal);
		hexa_hr_dec: hexa port map(a=>hr_decimal(7 downto 4),f=>display_5);
		hexa_hr_uni: hexa port map(a=>hr_decimal(3 downto 0),f=>display_4);
		
--======================================= MINUTOS =============================================================================================
		counter_min: counter_mod generic map(M=>60,N=>6) port map(g_reset_n=>g_reset_n,valor_inicial=>tiempo_inicial(11 downto 6),
																					en=>en_min,clk=>clk,q=>min);
		comparador_0_min: comparador generic map(N=>6) port map(A=>min,B=>"000000",EQ=>min_min);
		bintobcd_min: bintobcd port map(a=>min,f=>min_decimal);
		hexa_min_dec: hexa port map(a=>min_decimal(7 downto 4),f=>display_3);
		hexa_min_uni: hexa port map(a=>min_decimal(3 downto 0),f=>display_2);
		
--======================================= SEGUNDOS =============================================================================================
		counter_seg: counter_mod generic map(M=>60,N=>6) port map(g_reset_n=>g_reset_n,valor_inicial=>tiempo_inicial(5 downto 0),
																					en=>en_seg,clk=>clk,q=>seg);
		comparador_0_seg: comparador generic map(N=>6) port map(A=>seg,B=>"000000",EQ=>min_seg);
		bintobcd_seg: bintobcd port map(a=>seg,f=>seg_decimal);
		hexa_seg_dec: hexa port map(a=>seg_decimal(7 downto 4),f=>display_1);
		hexa_seg_uni: hexa port map(a=>seg_decimal(3 downto 0),f=>display_0);
		
		
		
end arch;