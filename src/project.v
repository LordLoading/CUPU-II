module cupu_fpu_Brtl
  (input  clk,
   input  rst,
   input  start,
   input  [3:0] op,
   input  [31:0] a,
   input  [31:0] b,
   output [31:0] res,
   output done);
  wire [4:0] state;
  wire [1:0] cont;
  wire [3:0] opn;
  wire [65:0] r;
  wire [65:0] x;
  wire [65:0] y;
  wire [65:0] z;
  wire [91:0] w;
  wire [23:0] ma;
  wire [23:0] mb;
  wire [10:0] ea;
  wire [10:0] eb;
  wire [10:0] er;
  wire [10:0] ed;
  wire sr;
  wire stk;
  wire effsub;
  wire [7:0] cnt;
  wire [1:0] quad;
  wire [31:0] res_r;
  wire done_r;
  wire [7:0] a_exp;
  wire [7:0] b_exp;
  wire [23:0] a_m;
  wire [23:0] b_m;
  wire [10:0] a_e;
  wire [10:0] b_e;
  wire a_nan;
  wire b_nan;
  wire a_inf;
  wire b_inf;
  wire a_zero;
  wire b_zero;
  wire sa;
  wire sb;
  wire sbe;
  wire [65:0] add_x;
  wire [65:0] add_y;
  wire add_inv;
  wire [66:0] add_s;
  wire add_ge;
  wire [65:0] shifted;
  wire [65:0] atan_i;
  wire [7:0] n1601;
  wire [7:0] n1602;
  wire n1605;
  wire n1606;
  wire n1610;
  wire n1611;
  wire [22:0] n1613;
  wire [22:0] n1614;
  wire n1621;
  wire n1625;
  wire [10:0] n1631;
  wire [30:0] n1632;
  wire [31:0] n1633;
  wire [31:0] n1635;
  wire [10:0] n1636;
  wire [10:0] n1641;
  wire n1648;
  wire n1652;
  wire [10:0] n1658;
  wire [30:0] n1659;
  wire [31:0] n1660;
  wire [31:0] n1662;
  wire [10:0] n1663;
  wire [10:0] n1668;
  wire n1671;
  wire [22:0] n1672;
  wire n1674;
  wire n1675;
  wire n1676;
  wire n1680;
  wire [22:0] n1681;
  wire n1683;
  wire n1684;
  wire n1685;
  wire n1689;
  wire [22:0] n1690;
  wire n1692;
  wire n1693;
  wire n1694;
  wire n1698;
  wire [22:0] n1699;
  wire n1701;
  wire n1702;
  wire n1703;
  wire [30:0] n1706;
  wire n1708;
  wire n1709;
  wire [30:0] n1712;
  wire n1714;
  wire n1715;
  wire n1717;
  wire n1718;
  wire n1719;
  wire n1721;
  wire [31:0] n1722;
  wire n1724;
  wire n1725;
  wire n1726;
  wire [5:0] n1727;
  wire [30:0] n1728;
  wire [65:0] n1729;
  wire n1731;
  wire [65:0] n1732;
  wire [5:0] n1733;
  wire [30:0] n1734;
  wire [65:0] n1735;
  wire n1739;
  wire [4:0] n1740;
  wire n1748;
  wire [5:0] n1749;
  wire [30:0] n1750;
  wire [31:0] n1751;
  wire [31:0] n1753;
  wire [30:0] n1754;
  wire [65:0] n1756;
  wire [65:0] n1758;
  wire [65:0] n1759;
  wire [65:0] n1764;
  wire n1765;
  wire n1767;
  wire n1769;
  wire n1771;
  wire n1773;
  wire [23:0] n1774;
  wire [65:0] n1775;
  wire n1776;
  wire [65:0] n1777;
  wire [65:0] n1779;
  wire n1781;
  wire [34:0] n1782;
  wire [65:0] n1783;
  wire [34:0] n1784;
  wire [65:0] n1785;
  wire n1787;
  wire [31:0] n1788;
  wire [1:0] n1789;
  wire [33:0] n1790;
  wire [65:0] n1791;
  wire [27:0] n1792;
  wire [29:0] n1794;
  wire [65:0] n1795;
  wire n1797;
  wire [23:0] n1798;
  wire [65:0] n1799;
  wire [7:0] n1802;
  wire [65:0] n1806;
  wire [65:0] n1808;
  wire n1810;
  wire [65:0] n1812;
  wire [6:0] n1813;
  wire [65:0] n1821;
  wire n1823;
  wire n1824;
  wire n1825;
  wire n1827;
  wire n1828;
  wire n1830;
  wire n1831;
  wire n1832;
  wire n1834;
  wire [31:0] n1835;
  wire n1837;
  wire n1838;
  wire n1839;
  wire n1840;
  wire [31:0] n1841;
  wire n1843;
  wire n1844;
  wire n1845;
  wire n1846;
  wire [31:0] n1847;
  wire n1849;
  wire n1851;
  wire n1852;
  wire n1853;
  wire n1854;
  wire n1855;
  wire [65:0] n1856;
  wire n1857;
  wire n1859;
  wire n1861;
  wire n1862;
  wire [12:0] n1863;
  reg [65:0] n1865;
  wire n1867;
  wire n1868;
  wire n1869;
  wire n1870;
  wire n1871;
  wire n1872;
  wire n1873;
  wire n1874;
  wire n1875;
  wire n1876;
  wire n1877;
  wire n1878;
  reg n1880;
  wire [64:0] n1881;
  wire [64:0] n1882;
  wire [64:0] n1883;
  wire [64:0] n1884;
  wire [64:0] n1885;
  wire [64:0] n1886;
  wire [64:0] n1887;
  wire [64:0] n1888;
  wire [64:0] n1889;
  wire [64:0] n1890;
  wire [64:0] n1891;
  wire [64:0] n1892;
  reg [64:0] n1894;
  reg n1900;
  wire [65:0] n1908;
  wire [65:0] n1909;
  wire [66:0] n1976;
  wire [66:0] n1978;
  wire [66:0] n1980;
  wire [66:0] n1981;
  wire [66:0] n1982;
  wire n1984;
  wire n1999;
  wire n2000;
  wire [65:0] n2001;
  wire [4:0] n2004;
  wire [65:0] n2005;
  wire [10:0] n2007;
  wire n2008;
  wire [31:0] n2010;
  wire n2012;
  wire n2014;
  wire n2016;
  wire [31:0] n2018;
  wire [65:0] n2019;
  wire [7:0] n2021;
  wire [4:0] n2024;
  wire [65:0] n2025;
  wire [7:0] n2026;
  wire [31:0] n2028;
  wire [4:0] n2030;
  wire [65:0] n2031;
  wire [7:0] n2032;
  wire [31:0] n2034;
  wire n2036;
  wire n2037;
  wire n2038;
  wire n2039;
  wire n2040;
  wire n2041;
  wire [30:0] n2042;
  wire [31:0] n2043;
  wire [30:0] n2044;
  wire [31:0] n2045;
  wire [30:0] n2046;
  wire [30:0] n2047;
  wire n2048;
  wire [31:0] n2049;
  wire [31:0] n2051;
  wire [10:0] n2052;
  wire [31:0] n2053;
  wire [31:0] n2054;
  wire [31:0] n2055;
  wire [10:0] n2056;
  wire [31:0] n2057;
  wire [31:0] n2059;
  wire [10:0] n2060;
  wire [31:0] n2061;
  wire [31:0] n2062;
  wire [31:0] n2063;
  wire [10:0] n2064;
  wire [23:0] n2065;
  localparam [65:0] n2066 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
  wire n2067;
  wire [40:0] n2068;
  wire [23:0] n2069;
  localparam [65:0] n2070 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
  wire n2071;
  wire [40:0] n2072;
  wire [10:0] n2073;
  wire n2074;
  wire [10:0] n2075;
  wire [31:0] n2076;
  wire n2078;
  wire [10:0] n2080;
  wire [7:0] n2082;
  wire n2083;
  wire [4:0] n2086;
  wire [65:0] n2087;
  wire [65:0] n2088;
  wire [65:0] n2089;
  wire [65:0] n2090;
  wire [10:0] n2091;
  wire n2092;
  wire n2093;
  wire [7:0] n2094;
  wire [31:0] n2095;
  wire [4:0] n2099;
  wire [65:0] n2100;
  wire [65:0] n2101;
  wire [10:0] n2102;
  wire n2103;
  wire n2104;
  wire [7:0] n2105;
  wire [31:0] n2106;
  wire [4:0] n2110;
  wire [65:0] n2111;
  wire [65:0] n2112;
  wire [10:0] n2113;
  wire n2114;
  wire n2115;
  wire [7:0] n2116;
  wire [31:0] n2118;
  wire n2122;
  wire n2124;
  wire n2125;
  wire n2126;
  wire n2127;
  wire n2128;
  wire n2129;
  wire n2130;
  wire n2131;
  wire n2132;
  wire n2133;
  wire [31:0] n2135;
  wire n2136;
  wire n2137;
  wire [31:0] n2139;
  wire [4:0] n2142;
  wire [31:0] n2143;
  wire [4:0] n2145;
  wire [31:0] n2146;
  wire [4:0] n2148;
  wire [31:0] n2150;
  wire n2152;
  wire n2153;
  wire n2154;
  wire n2155;
  wire n2156;
  wire n2157;
  wire n2158;
  wire n2159;
  wire n2160;
  wire [31:0] n2162;
  wire n2163;
  wire n2164;
  wire [31:0] n2166;
  wire [4:0] n2169;
  wire [31:0] n2170;
  wire [4:0] n2172;
  wire [31:0] n2173;
  wire [4:0] n2175;
  wire [31:0] n2177;
  wire n2179;
  wire n2180;
  wire n2181;
  wire n2182;
  wire n2183;
  wire [4:0] n2186;
  wire [31:0] n2187;
  wire [4:0] n2189;
  wire [31:0] n2191;
  wire n2193;
  wire n2194;
  wire n2196;
  wire [31:0] n2197;
  wire n2199;
  wire [31:0] n2201;
  wire n2203;
  wire [65:0] n2204;
  wire [7:0] n2206;
  wire [7:0] n2208;
  wire [4:0] n2211;
  wire [65:0] n2212;
  wire [91:0] n2214;
  wire [7:0] n2215;
  wire [1:0] n2217;
  wire [4:0] n2219;
  wire [65:0] n2220;
  wire [91:0] n2221;
  wire [7:0] n2222;
  wire [1:0] n2223;
  wire [31:0] n2224;
  wire [4:0] n2226;
  wire [65:0] n2227;
  wire [91:0] n2228;
  wire [7:0] n2229;
  wire [1:0] n2230;
  wire [31:0] n2232;
  wire n2234;
  wire n2236;
  wire n2237;
  wire n2239;
  wire n2240;
  wire [6:0] n2241;
  reg [4:0] n2243;
  reg [65:0] n2245;
  reg [65:0] n2246;
  reg [65:0] n2247;
  reg [91:0] n2248;
  reg [23:0] n2250;
  reg [10:0] n2251;
  reg n2253;
  reg n2254;
  reg [7:0] n2255;
  reg [1:0] n2256;
  reg [31:0] n2258;
  wire [4:0] n2261;
  wire [65:0] n2262;
  wire [65:0] n2263;
  wire [65:0] n2264;
  wire [91:0] n2265;
  wire [23:0] n2266;
  wire [10:0] n2267;
  wire n2268;
  wire n2269;
  wire [7:0] n2270;
  wire [1:0] n2271;
  wire [31:0] n2272;
  wire n2276;
  wire n2277;
  wire n2278;
  wire [22:0] n2279;
  wire [23:0] n2281;
  wire [31:0] n2282;
  wire [31:0] n2284;
  wire [10:0] n2285;
  wire n2286;
  wire n2287;
  wire [22:0] n2288;
  wire [23:0] n2290;
  wire [31:0] n2291;
  wire [31:0] n2293;
  wire [10:0] n2294;
  wire [65:0] n2295;
  wire n2297;
  wire [33:0] n2299;
  wire [65:0] n2300;
  wire [33:0] n2302;
  wire [65:0] n2303;
  wire [31:0] n2304;
  wire [31:0] n2305;
  wire [31:0] n2306;
  wire [31:0] n2308;
  wire [10:0] n2309;
  wire n2311;
  wire [31:0] n2312;
  wire n2313;
  wire [31:0] n2314;
  wire n2316;
  wire [65:0] n2317;
  wire [65:0] n2319;
  wire [31:0] n2320;
  wire [31:0] n2322;
  wire [31:0] n2324;
  wire [10:0] n2325;
  wire [65:0] n2326;
  wire [65:0] n2328;
  wire [31:0] n2329;
  wire [31:0] n2331;
  wire [31:0] n2333;
  wire [31:0] n2335;
  wire [10:0] n2336;
  wire [65:0] n2337;
  wire [10:0] n2338;
  wire [1:0] n2339;
  reg [4:0] n2343;
  reg [65:0] n2345;
  reg [65:0] n2347;
  reg [65:0] n2349;
  reg [65:0] n2351;
  reg [10:0] n2352;
  reg [7:0] n2356;
  wire [4:0] n2357;
  wire [65:0] n2358;
  wire [65:0] n2359;
  wire [65:0] n2360;
  wire [65:0] n2361;
  wire [23:0] n2362;
  wire [10:0] n2363;
  wire [10:0] n2364;
  wire [7:0] n2365;
  wire [4:0] n2366;
  wire [65:0] n2367;
  wire [65:0] n2368;
  wire [65:0] n2369;
  wire [65:0] n2370;
  wire [23:0] n2371;
  wire [23:0] n2372;
  wire [10:0] n2373;
  wire [10:0] n2374;
  wire [10:0] n2375;
  wire [7:0] n2376;
  wire n2378;
  wire n2380;
  wire [63:0] n2381;
  wire [64:0] n2383;
  wire n2384;
  wire n2385;
  wire n2386;
  wire [65:0] n2387;
  wire [7:0] n2389;
  wire [4:0] n2391;
  wire [65:0] n2392;
  wire [7:0] n2393;
  wire n2395;
  wire [65:0] n2396;
  wire [65:0] n2397;
  wire n2399;
  wire n2400;
  wire n2401;
  wire n2403;
  wire n2405;
  wire [64:0] n2406;
  wire [65:0] n2408;
  wire n2409;
  wire [7:0] n2411;
  wire [4:0] n2413;
  wire [65:0] n2414;
  wire n2415;
  wire [7:0] n2416;
  wire n2418;
  wire [65:0] n2419;
  wire n2421;
  wire [31:0] n2422;
  wire n2424;
  wire n2426;
  wire [31:0] n2427;
  wire [31:0] n2428;
  wire [31:0] n2429;
  wire [31:0] n2431;
  wire [10:0] n2432;
  wire [24:0] n2433;
  wire [22:0] n2434;
  wire [47:0] n2435;
  wire [64:0] n2436;
  wire [65:0] n2438;
  wire [7:0] n2440;
  wire [4:0] n2442;
  wire [65:0] n2443;
  wire [47:0] n2444;
  wire [47:0] n2445;
  wire [65:0] n2446;
  wire [10:0] n2447;
  wire [7:0] n2448;
  wire n2450;
  wire n2452;
  wire n2454;
  wire n2456;
  wire [64:0] n2457;
  wire [65:0] n2458;
  wire [64:0] n2459;
  wire [65:0] n2461;
  wire [64:0] n2462;
  wire [65:0] n2464;
  wire [65:0] n2465;
  wire [7:0] n2467;
  wire [4:0] n2469;
  wire [65:0] n2470;
  wire [65:0] n2471;
  wire n2472;
  wire [7:0] n2473;
  wire n2475;
  wire n2477;
  wire n2479;
  wire n2481;
  wire [65:0] n2482;
  wire [31:0] n2483;
  wire [1:0] n2484;
  wire [33:0] n2485;
  wire [65:0] n2486;
  wire [65:0] n2487;
  wire [64:0] n2488;
  wire [65:0] n2489;
  wire [63:0] n2490;
  wire [65:0] n2492;
  wire [7:0] n2494;
  wire [4:0] n2496;
  wire [65:0] n2497;
  wire [65:0] n2498;
  wire [65:0] n2499;
  wire [65:0] n2500;
  wire n2501;
  wire [7:0] n2502;
  wire n2504;
  wire n2506;
  wire [64:0] n2507;
  wire [65:0] n2509;
  wire [7:0] n2511;
  wire [4:0] n2513;
  wire [65:0] n2514;
  wire [7:0] n2515;
  wire n2517;
  wire [24:0] n2518;
  wire [66:0] n2519;
  wire [91:0] n2520;
  wire [30:0] n2521;
  wire [31:0] n2522;
  wire [31:0] n2524;
  wire [10:0] n2525;
  wire [31:0] n2526;
  wire n2528;
  wire [10:0] n2530;
  wire [30:0] n2531;
  wire [31:0] n2532;
  wire [31:0] n2533;
  wire n2534;
  wire n2536;
  wire [7:0] n2538;
  wire [7:0] n2540;
  wire [7:0] n2542;
  wire [4:0] n2544;
  wire [7:0] n2545;
  wire n2547;
  wire n2549;
  wire [90:0] n2550;
  wire [91:0] n2552;
  wire [7:0] n2554;
  wire [4:0] n2556;
  wire [91:0] n2557;
  wire [7:0] n2558;
  wire n2560;
  wire [1:0] n2561;
  wire n2562;
  wire [1:0] n2564;
  wire [1:0] n2565;
  wire [65:0] n2566;
  wire [65:0] n2568;
  wire n2570;
  wire [65:0] n2571;
  wire n2573;
  wire [7:0] n2575;
  wire [4:0] n2577;
  wire [7:0] n2578;
  wire n2580;
  wire [23:0] n2581;
  wire n2583;
  wire [23:0] n2584;
  wire [23:0] n2585;
  wire n2587;
  wire n2588;
  wire [4:0] n2591;
  wire [65:0] n2594;
  wire [65:0] n2596;
  wire [7:0] n2598;
  wire n2600;
  wire [65:0] n2601;
  wire n2603;
  wire [65:0] n2604;
  wire n2606;
  wire [65:0] n2607;
  wire [65:0] n2608;
  wire n2610;
  wire [7:0] n2612;
  wire [4:0] n2615;
  wire [7:0] n2616;
  wire n2618;
  wire [31:0] n2619;
  wire n2621;
  wire n2622;
  wire n2623;
  wire n2624;
  wire n2625;
  wire n2626;
  wire n2627;
  wire n2628;
  wire n2629;
  wire n2630;
  wire n2631;
  wire n2632;
  wire n2633;
  wire [31:0] n2634;
  wire n2636;
  wire n2637;
  wire n2638;
  wire [65:0] n2639;
  wire n2640;
  wire n2641;
  wire n2642;
  wire n2643;
  wire n2644;
  wire n2645;
  wire [65:0] n2646;
  wire n2647;
  wire n2648;
  wire n2649;
  wire n2650;
  wire n2651;
  wire n2652;
  wire [1:0] n2655;
  wire n2656;
  wire [65:0] n2660;
  wire n2662;
  wire [65:0] n2663;
  wire n2665;
  wire [33:0] n2666;
  wire [65:0] n2667;
  wire [33:0] n2668;
  wire [65:0] n2669;
  wire [31:0] n2670;
  wire [31:0] n2671;
  wire [31:0] n2672;
  wire [31:0] n2674;
  wire [10:0] n2675;
  wire n2677;
  wire n2679;
  wire n2680;
  wire n2681;
  wire n2683;
  wire n2684;
  wire [64:0] n2685;
  wire [65:0] n2687;
  wire [31:0] n2688;
  wire [31:0] n2690;
  wire [10:0] n2691;
  wire n2693;
  wire [4:0] n2696;
  wire [4:0] n2697;
  wire [65:0] n2698;
  wire [10:0] n2699;
  wire n2701;
  wire [31:0] n2702;
  wire n2704;
  wire [64:0] n2705;
  wire [65:0] n2707;
  wire n2708;
  wire n2709;
  wire [31:0] n2710;
  wire [31:0] n2712;
  wire [10:0] n2713;
  wire n2714;
  wire n2715;
  wire [31:0] n2716;
  wire n2718;
  wire n2719;
  wire [64:0] n2720;
  wire [65:0] n2722;
  wire [31:0] n2723;
  wire [31:0] n2725;
  wire [10:0] n2726;
  wire [4:0] n2728;
  wire [65:0] n2729;
  wire [10:0] n2730;
  wire [4:0] n2731;
  wire [65:0] n2732;
  wire [10:0] n2733;
  wire n2734;
  wire [4:0] n2736;
  wire [65:0] n2737;
  wire [10:0] n2738;
  wire n2739;
  wire [4:0] n2740;
  wire [65:0] n2741;
  wire [10:0] n2742;
  wire n2743;
  wire n2745;
  wire [40:0] n2746;
  wire n2748;
  wire n2750;
  wire n2751;
  wire n2752;
  wire n2753;
  wire n2754;
  wire [23:0] n2755;
  wire [24:0] n2757;
  wire [24:0] n2759;
  wire [24:0] n2760;
  wire n2761;
  wire [23:0] n2762;
  wire [24:0] n2764;
  wire [31:0] n2765;
  wire [31:0] n2767;
  wire [10:0] n2768;
  wire [24:0] n2769;
  wire [10:0] n2770;
  wire n2772;
  wire n2773;
  wire n2774;
  wire [31:0] n2776;
  wire n2777;
  wire n2778;
  wire [8:0] n2780;
  wire [22:0] n2781;
  wire [31:0] n2782;
  wire [31:0] n2783;
  wire n2785;
  wire [31:0] n2787;
  wire [31:0] n2788;
  wire [31:0] n2790;
  wire [30:0] n2791;
  wire [7:0] n2792;
  wire [8:0] n2793;
  wire [22:0] n2794;
  wire [31:0] n2795;
  wire [31:0] n2796;
  wire [31:0] n2797;
  wire [31:0] n2798;
  wire n2800;
  wire n2802;
  wire [24:0] n2803;
  reg [4:0] n2816;
  reg [1:0] n2821;
  reg [65:0] n2824;
  wire [47:0] n2825;
  wire [47:0] n2826;
  wire [47:0] n2827;
  wire [47:0] n2828;
  wire [47:0] n2829;
  wire [47:0] n2830;
  wire [47:0] n2831;
  wire [47:0] n2832;
  wire [47:0] n2833;
  wire [47:0] n2834;
  wire [47:0] n2835;
  wire [47:0] n2836;
  reg [47:0] n2838;
  wire [17:0] n2839;
  wire [17:0] n2840;
  wire [17:0] n2841;
  wire [17:0] n2842;
  wire [17:0] n2843;
  wire [17:0] n2844;
  wire [17:0] n2845;
  wire [17:0] n2846;
  wire [17:0] n2847;
  wire [17:0] n2848;
  wire [17:0] n2849;
  wire [17:0] n2850;
  reg [17:0] n2852;
  reg [65:0] n2854;
  reg [65:0] n2857;
  wire [65:0] n2858;
  wire [65:0] n2859;
  wire [65:0] n2860;
  wire [65:0] n2861;
  reg [65:0] n2863;
  wire [25:0] n2864;
  wire [25:0] n2865;
  wire [25:0] n2866;
  wire [25:0] n2867;
  reg [25:0] n2869;
  reg [23:0] n2871;
  reg [23:0] n2873;
  reg [10:0] n2875;
  reg [10:0] n2877;
  reg [10:0] n2881;
  reg [10:0] n2883;
  reg n2885;
  reg n2889;
  reg n2891;
  reg [7:0] n2895;
  reg [1:0] n2897;
  reg [31:0] n2899;
  reg n2903;
  wire [4:0] n2925;
  wire [1:0] n2926;
  wire [65:0] n2927;
  wire [65:0] n2928;
  wire [65:0] n2929;
  wire [65:0] n2930;
  wire [65:0] n2931;
  wire [91:0] n2932;
  wire [91:0] n2933;
  wire [23:0] n2934;
  wire [23:0] n2935;
  wire [10:0] n2936;
  wire [10:0] n2937;
  wire [10:0] n2938;
  wire [10:0] n2939;
  wire n2940;
  wire n2941;
  wire n2942;
  wire [7:0] n2943;
  wire [1:0] n2944;
  wire [31:0] n2945;
  wire n2947;
  wire [23:0] n2990;
  wire [23:0] n2991;
  wire [65:0] n2992;
  reg [4:0] n2993;
  reg [1:0] n2994;
  reg [65:0] n2995;
  reg [65:0] n2996;
  reg [65:0] n2997;
  reg [65:0] n2998;
  reg [91:0] n2999;
  reg [23:0] n3000;
  reg [23:0] n3001;
  reg [10:0] n3002;
  reg [10:0] n3003;
  reg [10:0] n3004;
  reg [10:0] n3005;
  reg n3006;
  reg n3007;
  reg n3008;
  reg [7:0] n3009;
  reg [1:0] n3010;
  reg [31:0] n3011;
  reg n3012;
  wire [65:0] n3015; // mem_rd
  wire n3017; // mem_rd
  wire n3020; // mem_rd
  assign res = res_r; //(module output)
  assign done = done_r; //(module output)
  /*# cupu_fpu.vhd:71:10 */
  assign state = n2993; // (signal)
  /*# cupu_fpu.vhd:72:10 */
  assign cont = n2994; // (signal)
  /*# cupu_fpu.vhd:73:10 */
  assign opn = op; // (signal)
  /*# cupu_fpu.vhd:75:10 */
  assign r = n2995; // (signal)
  /*# cupu_fpu.vhd:75:13 */
  assign x = n2996; // (signal)
  /*# cupu_fpu.vhd:75:16 */
  assign y = n2997; // (signal)
  /*# cupu_fpu.vhd:75:19 */
  assign z = n2998; // (signal)
  /*# cupu_fpu.vhd:76:10 */
  assign w = n2999; // (signal)
  /*# cupu_fpu.vhd:77:10 */
  assign ma = n3000; // (signal)
  /*# cupu_fpu.vhd:77:14 */
  assign mb = n3001; // (signal)
  /*# cupu_fpu.vhd:78:10 */
  assign ea = n3002; // (signal)
  /*# cupu_fpu.vhd:78:14 */
  assign eb = n3003; // (signal)
  /*# cupu_fpu.vhd:79:10 */
  assign er = n3004; // (signal)
  /*# cupu_fpu.vhd:79:14 */
  assign ed = n3005; // (signal)
  /*# cupu_fpu.vhd:80:10 */
  assign sr = n3006; // (signal)
  /*# cupu_fpu.vhd:80:14 */
  assign stk = n3007; // (signal)
  /*# cupu_fpu.vhd:81:10 */
  assign effsub = n3008; // (signal)
  /*# cupu_fpu.vhd:82:10 */
  assign cnt = n3009; // (signal)
  /*# cupu_fpu.vhd:83:10 */
  assign quad = n3010; // (signal)
  /*# cupu_fpu.vhd:84:10 */
  assign res_r = n3011; // (signal)
  /*# cupu_fpu.vhd:85:10 */
  assign done_r = n3012; // (signal)
  /*# cupu_fpu.vhd:88:10 */
  assign a_exp = n1601; // (signal)
  /*# cupu_fpu.vhd:88:17 */
  assign b_exp = n1602; // (signal)
  /*# cupu_fpu.vhd:89:10 */
  assign a_m = n2990; // (signal)
  /*# cupu_fpu.vhd:89:15 */
  assign b_m = n2991; // (signal)
  /*# cupu_fpu.vhd:90:10 */
  assign a_e = n1641; // (signal)
  /*# cupu_fpu.vhd:90:15 */
  assign b_e = n1668; // (signal)
  /*# cupu_fpu.vhd:91:10 */
  assign a_nan = n1676; // (signal)
  /*# cupu_fpu.vhd:91:17 */
  assign b_nan = n1685; // (signal)
  /*# cupu_fpu.vhd:92:10 */
  assign a_inf = n1694; // (signal)
  /*# cupu_fpu.vhd:92:17 */
  assign b_inf = n1703; // (signal)
  /*# cupu_fpu.vhd:93:10 */
  assign a_zero = n1709; // (signal)
  /*# cupu_fpu.vhd:93:18 */
  assign b_zero = n1715; // (signal)
  /*# cupu_fpu.vhd:94:10 */
  assign sa = n1717; // (signal)
  /*# cupu_fpu.vhd:94:14 */
  assign sb = n1718; // (signal)
  /*# cupu_fpu.vhd:94:18 */
  assign sbe = n1725; // (signal)
  /*# cupu_fpu.vhd:97:10 */
  assign add_x = n1865; // (signal)
  /*# cupu_fpu.vhd:97:17 */
  assign add_y = n2992; // (signal)
  /*# cupu_fpu.vhd:98:10 */
  assign add_inv = n1900; // (signal)
  /*# cupu_fpu.vhd:99:10 */
  assign add_s = n1982; // (signal)
  /*# cupu_fpu.vhd:100:10 */
  assign add_ge = n1984; // (signal)
  /*# cupu_fpu.vhd:102:10 */
  assign shifted = n1732; // (signal)
  /*# cupu_fpu.vhd:103:10 */
  assign atan_i = n1759; // (signal)
  /*# cupu_fpu.vhd:117:23 */
  assign n1601 = a[30:23]; // extract
  /*# cupu_fpu.vhd:118:23 */
  assign n1602 = b[30:23]; // extract
  /*# cupu_fpu.vhd:119:29 */
  assign n1605 = a_exp == 8'b00000000;
  /*# cupu_fpu.vhd:119:18 */
  assign n1606 = n1605 ? 1'b0 : 1'b1;
  /*# cupu_fpu.vhd:120:29 */
  assign n1610 = b_exp == 8'b00000000;
  /*# cupu_fpu.vhd:120:18 */
  assign n1611 = n1610 ? 1'b0 : 1'b1;
  /*# cupu_fpu.vhd:121:33 */
  assign n1613 = a[22:0]; // extract
  /*# cupu_fpu.vhd:122:33 */
  assign n1614 = b[22:0]; // extract
  /*# cupu_fpu.vhd:107:10 */
  assign n1621 = a_exp == 8'b00000000;
  /*# cupu_fpu.vhd:107:5 */
  assign n1625 = n1621 ? 1'b0 : 1'b1;
  /*# cupu_fpu.vhd:107:5 */
  assign n1631 = n1621 ? 11'b11110000010 : 11'bX;
  /*# cupu_fpu.vhd:110:12 */
  assign n1632 = {23'b0, a_exp};  // uext
  /*# cupu_fpu.vhd:110:26 */
  assign n1633 = {1'b0, n1632};  // uext
  /*# cupu_fpu.vhd:110:26 */
  assign n1635 = n1633 - 32'b00000000000000000000000001111111;
  /*# cupu_fpu.vhd:110:5 */
  assign n1636 = n1635[10:0];  // trunc
  /*# cupu_fpu.vhd:110:5 */
  assign n1641 = n1625 ? n1636 : n1631;
  /*# cupu_fpu.vhd:107:10 */
  assign n1648 = b_exp == 8'b00000000;
  /*# cupu_fpu.vhd:107:5 */
  assign n1652 = n1648 ? 1'b0 : 1'b1;
  /*# cupu_fpu.vhd:107:5 */
  assign n1658 = n1648 ? 11'b11110000010 : 11'bX;
  /*# cupu_fpu.vhd:110:12 */
  assign n1659 = {23'b0, b_exp};  // uext
  /*# cupu_fpu.vhd:110:26 */
  assign n1660 = {1'b0, n1659};  // uext
  /*# cupu_fpu.vhd:110:26 */
  assign n1662 = n1660 - 32'b00000000000000000000000001111111;
  /*# cupu_fpu.vhd:110:5 */
  assign n1663 = n1662[10:0];  // trunc
  /*# cupu_fpu.vhd:110:5 */
  assign n1668 = n1652 ? n1663 : n1658;
  /*# cupu_fpu.vhd:125:28 */
  assign n1671 = a_exp == 8'b11111111;
  /*# cupu_fpu.vhd:125:48 */
  assign n1672 = a[22:0]; // extract
  /*# cupu_fpu.vhd:125:63 */
  assign n1674 = n1672 != 23'b00000000000000000000000;
  /*# cupu_fpu.vhd:125:34 */
  assign n1675 = n1674 & n1671;
  /*# cupu_fpu.vhd:125:17 */
  assign n1676 = n1675 ? 1'b1 : 1'b0;
  /*# cupu_fpu.vhd:126:28 */
  assign n1680 = b_exp == 8'b11111111;
  /*# cupu_fpu.vhd:126:48 */
  assign n1681 = b[22:0]; // extract
  /*# cupu_fpu.vhd:126:63 */
  assign n1683 = n1681 != 23'b00000000000000000000000;
  /*# cupu_fpu.vhd:126:34 */
  assign n1684 = n1683 & n1680;
  /*# cupu_fpu.vhd:126:17 */
  assign n1685 = n1684 ? 1'b1 : 1'b0;
  /*# cupu_fpu.vhd:127:28 */
  assign n1689 = a_exp == 8'b11111111;
  /*# cupu_fpu.vhd:127:48 */
  assign n1690 = a[22:0]; // extract
  /*# cupu_fpu.vhd:127:63 */
  assign n1692 = n1690 == 23'b00000000000000000000000;
  /*# cupu_fpu.vhd:127:34 */
  assign n1693 = n1692 & n1689;
  /*# cupu_fpu.vhd:127:17 */
  assign n1694 = n1693 ? 1'b1 : 1'b0;
  /*# cupu_fpu.vhd:128:28 */
  assign n1698 = b_exp == 8'b11111111;
  /*# cupu_fpu.vhd:128:48 */
  assign n1699 = b[22:0]; // extract
  /*# cupu_fpu.vhd:128:63 */
  assign n1701 = n1699 == 23'b00000000000000000000000;
  /*# cupu_fpu.vhd:128:34 */
  assign n1702 = n1701 & n1698;
  /*# cupu_fpu.vhd:128:17 */
  assign n1703 = n1702 ? 1'b1 : 1'b0;
  /*# cupu_fpu.vhd:129:32 */
  assign n1706 = a[30:0]; // extract
  /*# cupu_fpu.vhd:129:47 */
  assign n1708 = n1706 == 31'b0000000000000000000000000000000;
  /*# cupu_fpu.vhd:129:17 */
  assign n1709 = n1708 ? 1'b1 : 1'b0;
  /*# cupu_fpu.vhd:130:32 */
  assign n1712 = b[30:0]; // extract
  /*# cupu_fpu.vhd:130:47 */
  assign n1714 = n1712 == 31'b0000000000000000000000000000000;
  /*# cupu_fpu.vhd:130:17 */
  assign n1715 = n1714 ? 1'b1 : 1'b0;
  /*# cupu_fpu.vhd:131:14 */
  assign n1717 = a[31]; // extract
  /*# cupu_fpu.vhd:132:14 */
  assign n1718 = b[31]; // extract
  /*# cupu_fpu.vhd:133:14 */
  assign n1719 = b[31]; // extract
  /*# cupu_fpu.vhd:133:19 */
  assign n1721 = n1719 ^ 1'b1;
  /*# cupu_fpu.vhd:133:36 */
  assign n1722 = {28'b0, opn};  // uext
  /*# cupu_fpu.vhd:133:36 */
  assign n1724 = n1722 == 32'b00000000000000000000000000000011;
  /*# cupu_fpu.vhd:133:27 */
  assign n1725 = n1724 ? n1721 : n1726;
  /*# cupu_fpu.vhd:133:52 */
  assign n1726 = b[31]; // extract
  /*# cupu_fpu.vhd:135:60 */
  assign n1727 = cnt[5:0]; // extract
  /*# cupu_fpu.vhd:135:46 */
  assign n1728 = {25'b0, n1727};  // uext
  /*# cupu_fpu.vhd:135:23 */
  assign n1729 = $signed(y) >>> n1728;
  /*# cupu_fpu.vhd:135:87 */
  assign n1731 = state == 5'b10000;
  /*# cupu_fpu.vhd:135:76 */
  assign n1732 = n1731 ? n1729 : n1735;
  /*# cupu_fpu.vhd:136:60 */
  assign n1733 = cnt[5:0]; // extract
  /*# cupu_fpu.vhd:136:46 */
  assign n1734 = {25'b0, n1733};  // uext
  /*# cupu_fpu.vhd:136:23 */
  assign n1735 = $signed(x) >>> n1734;
  /*# cupu_fpu.vhd:140:12 */
  assign n1739 = $unsigned(cnt) <= $unsigned(8'b00010100);
  /*# cupu_fpu.vhd:141:40 */
  assign n1740 = cnt[4:0]; // extract
  /*# cupu_fpu.vhd:142:15 */
  assign n1748 = $unsigned(cnt) > $unsigned(8'b00111110);
  /*# cupu_fpu.vhd:145:67 */
  assign n1749 = cnt[5:0]; // extract
  /*# cupu_fpu.vhd:145:53 */
  assign n1750 = {25'b0, n1749};  // uext
  /*# cupu_fpu.vhd:145:51 */
  assign n1751 = {1'b0, n1750};  // uext
  /*# cupu_fpu.vhd:145:51 */
  assign n1753 = 32'b00000000000000000000000000111110 - n1751;
  /*# cupu_fpu.vhd:145:48 */
  assign n1754 = n1753[30:0];  // trunc
  /*# cupu_fpu.vhd:145:17 */
  assign n1756 = 66'b000000000000000000000000000000000000000000000000000000000000000001 << n1754;
  /*# cupu_fpu.vhd:142:5 */
  assign n1758 = n1748 ? 66'b000000000000000000000000000000000000000000000000000000000000000000 : n1756;
  /*# cupu_fpu.vhd:140:5 */
  assign n1759 = n1739 ? n3015 : n1758;
  /*# cupu_fpu.vhd:160:29 */
  assign n1764 = {{34{a[31]}}, a}; // sext
  /*# cupu_fpu.vhd:161:21 */
  assign n1765 = a[31]; // extract
  /*# cupu_fpu.vhd:159:7 */
  assign n1767 = state == 5'b00000;
  /*# cupu_fpu.vhd:162:7 */
  assign n1769 = state == 5'b00011;
  /*# cupu_fpu.vhd:166:7 */
  assign n1771 = state == 5'b00101;
  /*# cupu_fpu.vhd:169:7 */
  assign n1773 = state == 5'b00110;
  /*# cupu_fpu.vhd:173:26 */
  assign n1774 = x[47:24]; // extract
  /*# cupu_fpu.vhd:173:18 */
  assign n1775 = {42'b0, n1774};  // uext
  /*# cupu_fpu.vhd:174:13 */
  assign n1776 = y[0]; // extract
  /*# cupu_fpu.vhd:175:20 */
  assign n1777 = {42'b0, mb};  // uext
  /*# cupu_fpu.vhd:174:9 */
  assign n1779 = n1776 ? n1777 : 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:172:7 */
  assign n1781 = state == 5'b00111;
  /*# cupu_fpu.vhd:178:28 */
  assign n1782 = x[34:0]; // extract
  /*# cupu_fpu.vhd:178:20 */
  assign n1783 = {31'b0, n1782};  // uext
  /*# cupu_fpu.vhd:179:28 */
  assign n1784 = y[34:0]; // extract
  /*# cupu_fpu.vhd:179:20 */
  assign n1785 = {31'b0, n1784};  // uext
  /*# cupu_fpu.vhd:177:7 */
  assign n1787 = state == 5'b01000;
  /*# cupu_fpu.vhd:182:28 */
  assign n1788 = y[31:0]; // extract
  /*# cupu_fpu.vhd:182:45 */
  assign n1789 = x[55:54]; // extract
  /*# cupu_fpu.vhd:182:42 */
  assign n1790 = {n1788, n1789};
  /*# cupu_fpu.vhd:182:20 */
  assign n1791 = {32'b0, n1790};  // uext
  /*# cupu_fpu.vhd:183:28 */
  assign n1792 = z[27:0]; // extract
  /*# cupu_fpu.vhd:183:42 */
  assign n1794 = {n1792, 2'b01};
  /*# cupu_fpu.vhd:183:20 */
  assign n1795 = {36'b0, n1794};  // uext
  /*# cupu_fpu.vhd:181:7 */
  assign n1797 = state == 5'b01001;
  /*# cupu_fpu.vhd:186:26 */
  assign n1798 = w[91:68]; // extract
  /*# cupu_fpu.vhd:186:18 */
  assign n1799 = {42'b0, n1798};  // uext
  /*# cupu_fpu.vhd:187:24 */
  assign n1802 = 8'b11001000 - cnt;
  /*# cupu_fpu.vhd:188:20 */
  assign n1806 = {42'b0, ma};  // uext
  /*# cupu_fpu.vhd:187:9 */
  assign n1808 = n3017 ? n1806 : 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:185:7 */
  assign n1810 = state == 5'b01011;
  /*# cupu_fpu.vhd:191:27 */
  assign n1812 = $signed(z) >>> 31'b0000000000000000000000000000001;
  /*# cupu_fpu.vhd:192:34 */
  assign n1813 = cnt[6:0]; // extract
  /*# cupu_fpu.vhd:192:9 */
  assign n1821 = n3020 ? x : 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:190:7 */
  assign n1823 = state == 5'b01110;
  /*# cupu_fpu.vhd:201:25 */
  assign n1824 = z[65]; // extract
  /*# cupu_fpu.vhd:201:20 */
  assign n1825 = ~n1824;
  /*# cupu_fpu.vhd:198:7 */
  assign n1827 = state == 5'b10000;
  /*# cupu_fpu.vhd:205:21 */
  assign n1828 = z[65]; // extract
  /*# cupu_fpu.vhd:202:7 */
  assign n1830 = state == 5'b10001;
  /*# cupu_fpu.vhd:209:25 */
  assign n1831 = z[65]; // extract
  /*# cupu_fpu.vhd:209:20 */
  assign n1832 = ~n1831;
  /*# cupu_fpu.vhd:206:7 */
  assign n1834 = state == 5'b10010;
  /*# cupu_fpu.vhd:213:17 */
  assign n1835 = {28'b0, opn};  // uext
  /*# cupu_fpu.vhd:213:17 */
  assign n1837 = n1835 == 32'b00000000000000000000000000000111;
  /*# cupu_fpu.vhd:213:34 */
  assign n1838 = quad[0]; // extract
  /*# cupu_fpu.vhd:213:38 */
  assign n1839 = ~n1838;
  /*# cupu_fpu.vhd:213:26 */
  assign n1840 = n1839 & n1837;
  /*# cupu_fpu.vhd:213:53 */
  assign n1841 = {28'b0, opn};  // uext
  /*# cupu_fpu.vhd:213:53 */
  assign n1843 = n1841 == 32'b00000000000000000000000000001000;
  /*# cupu_fpu.vhd:213:70 */
  assign n1844 = quad[0]; // extract
  /*# cupu_fpu.vhd:213:62 */
  assign n1845 = n1844 & n1843;
  /*# cupu_fpu.vhd:213:45 */
  assign n1846 = n1840 | n1845;
  /*# cupu_fpu.vhd:214:17 */
  assign n1847 = {28'b0, opn};  // uext
  /*# cupu_fpu.vhd:214:17 */
  assign n1849 = n1847 == 32'b00000000000000000000000000001001;
  /*# cupu_fpu.vhd:214:37 */
  assign n1851 = state == 5'b10011;
  /*# cupu_fpu.vhd:214:58 */
  assign n1852 = quad[0]; // extract
  /*# cupu_fpu.vhd:214:51 */
  assign n1853 = n1851 == n1852;
  /*# cupu_fpu.vhd:214:26 */
  assign n1854 = n1853 & n1849;
  /*# cupu_fpu.vhd:213:81 */
  assign n1855 = n1846 | n1854;
  /*# cupu_fpu.vhd:213:9 */
  assign n1856 = n1855 ? y : x;
  /*# cupu_fpu.vhd:220:21 */
  assign n1857 = n1856[65]; // extract
  /*# cupu_fpu.vhd:210:7 */
  assign n1859 = state == 5'b10011;
  /*# cupu_fpu.vhd:210:23 */
  assign n1861 = state == 5'b10100;
  /*# cupu_fpu.vhd:210:23 */
  assign n1862 = n1859 | n1861;
  /*# cupu_fpu.vhd:158:5 */
  assign n1863 = {n1862, n1834, n1830, n1827, n1823, n1810, n1797, n1787, n1781, n1773, n1771, n1769, n1767};
  /*# cupu_fpu.vhd:158:5 */
  always @*
    case (n1863)
      13'b1000000000000: n1865 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
      13'b0100000000000: n1865 = z;
      13'b0010000000000: n1865 = y;
      13'b0001000000000: n1865 = x;
      13'b0000100000000: n1865 = n1812;
      13'b0000010000000: n1865 = n1799;
      13'b0000001000000: n1865 = n1791;
      13'b0000000100000: n1865 = n1783;
      13'b0000000010000: n1865 = n1775;
      13'b0000000001000: n1865 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
      13'b0000000000100: n1865 = x;
      13'b0000000000010: n1865 = r;
      13'b0000000000001: n1865 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
      default: n1865 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
    endcase
  /*# cupu_fpu.vhd:160:29 */
  assign n1867 = n1764[0]; // extract
  /*# cupu_fpu.vhd:75:13 */
  assign n1868 = x[0]; // extract
  /*# cupu_fpu.vhd:75:13 */
  assign n1869 = x[0]; // extract
  /*# cupu_fpu.vhd:174:9 */
  assign n1870 = n1779[0]; // extract
  /*# cupu_fpu.vhd:179:20 */
  assign n1871 = n1785[0]; // extract
  /*# cupu_fpu.vhd:183:20 */
  assign n1872 = n1795[0]; // extract
  /*# cupu_fpu.vhd:187:9 */
  assign n1873 = n1808[0]; // extract
  /*# cupu_fpu.vhd:192:9 */
  assign n1874 = n1821[0]; // extract
  /*# cupu_fpu.vhd:102:10 */
  assign n1875 = shifted[0]; // extract
  /*# cupu_fpu.vhd:102:10 */
  assign n1876 = shifted[0]; // extract
  /*# cupu_fpu.vhd:103:10 */
  assign n1877 = atan_i[0]; // extract
  /*# cupu_fpu.vhd:213:9 */
  assign n1878 = n1856[0]; // extract
  /*# cupu_fpu.vhd:158:5 */
  always @*
    case (n1863)
      13'b1000000000000: n1880 = n1878;
      13'b0100000000000: n1880 = n1877;
      13'b0010000000000: n1880 = n1876;
      13'b0001000000000: n1880 = n1875;
      13'b0000100000000: n1880 = n1874;
      13'b0000010000000: n1880 = n1873;
      13'b0000001000000: n1880 = n1872;
      13'b0000000100000: n1880 = n1871;
      13'b0000000010000: n1880 = n1870;
      13'b0000000001000: n1880 = n1869;
      13'b0000000000100: n1880 = stk;
      13'b0000000000010: n1880 = n1868;
      13'b0000000000001: n1880 = n1867;
      default: n1880 = 1'b0;
    endcase
  /*# cupu_fpu.vhd:160:29 */
  assign n1881 = n1764[65:1]; // extract
  /*# cupu_fpu.vhd:75:13 */
  assign n1882 = x[65:1]; // extract
  /*# cupu_fpu.vhd:75:13 */
  assign n1883 = x[65:1]; // extract
  /*# cupu_fpu.vhd:174:9 */
  assign n1884 = n1779[65:1]; // extract
  /*# cupu_fpu.vhd:179:20 */
  assign n1885 = n1785[65:1]; // extract
  /*# cupu_fpu.vhd:183:20 */
  assign n1886 = n1795[65:1]; // extract
  /*# cupu_fpu.vhd:187:9 */
  assign n1887 = n1808[65:1]; // extract
  /*# cupu_fpu.vhd:192:9 */
  assign n1888 = n1821[65:1]; // extract
  /*# cupu_fpu.vhd:102:10 */
  assign n1889 = shifted[65:1]; // extract
  /*# cupu_fpu.vhd:102:10 */
  assign n1890 = shifted[65:1]; // extract
  /*# cupu_fpu.vhd:103:10 */
  assign n1891 = atan_i[65:1]; // extract
  /*# cupu_fpu.vhd:213:9 */
  assign n1892 = n1856[65:1]; // extract
  /*# cupu_fpu.vhd:158:5 */
  always @*
    case (n1863)
      13'b1000000000000: n1894 = n1892;
      13'b0100000000000: n1894 = n1891;
      13'b0010000000000: n1894 = n1890;
      13'b0001000000000: n1894 = n1889;
      13'b0000100000000: n1894 = n1888;
      13'b0000010000000: n1894 = n1887;
      13'b0000001000000: n1894 = n1886;
      13'b0000000100000: n1894 = n1885;
      13'b0000000010000: n1894 = n1884;
      13'b0000000001000: n1894 = n1883;
      13'b0000000000100: n1894 = 65'b00000000000000000000000000000000000000000000000000000000000000000;
      13'b0000000000010: n1894 = n1882;
      13'b0000000000001: n1894 = n1881;
      default: n1894 = 65'b00000000000000000000000000000000000000000000000000000000000000000;
    endcase
  /*# cupu_fpu.vhd:158:5 */
  always @*
    case (n1863)
      13'b1000000000000: n1900 = n1857;
      13'b0100000000000: n1900 = n1832;
      13'b0010000000000: n1900 = n1828;
      13'b0001000000000: n1900 = n1825;
      13'b0000100000000: n1900 = 1'b0;
      13'b0000010000000: n1900 = 1'b0;
      13'b0000001000000: n1900 = 1'b1;
      13'b0000000100000: n1900 = 1'b1;
      13'b0000000010000: n1900 = 1'b0;
      13'b0000000001000: n1900 = sa;
      13'b0000000000100: n1900 = 1'b0;
      13'b0000000000010: n1900 = effsub;
      13'b0000000000001: n1900 = n1765;
      default: n1900 = 1'b0;
    endcase
  /*# cupu_fpu.vhd:231:13 */
  assign n1908 = ~add_y;
  /*# cupu_fpu.vhd:230:5 */
  assign n1909 = add_inv ? n1908 : add_y;
  /*# cupu_fpu.vhd:233:10 */
  assign n1976 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, add_inv};
  /*# cupu_fpu.vhd:234:19 */
  assign n1978 = {1'b0, add_x};
  /*# cupu_fpu.vhd:234:35 */
  assign n1980 = {1'b0, n1909};
  /*# cupu_fpu.vhd:234:28 */
  assign n1981 = n1978 + n1980;
  /*# cupu_fpu.vhd:234:41 */
  assign n1982 = n1981 + n1976;
  /*# cupu_fpu.vhd:236:18 */
  assign n1984 = add_s[66]; // extract
  /*# cupu_fpu.vhd:271:24 */
  assign n1999 = a == 32'b00000000000000000000000000000000;
  /*# cupu_fpu.vhd:274:31 */
  assign n2000 = a[31]; // extract
  /*# cupu_fpu.vhd:275:35 */
  assign n2001 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:271:19 */
  assign n2004 = n1999 ? 5'b11000 : 5'b10110;
  /*# cupu_fpu.vhd:271:19 */
  assign n2005 = n1999 ? r : n2001;
  /*# cupu_fpu.vhd:271:19 */
  assign n2007 = n1999 ? er : 11'b00001000001;
  /*# cupu_fpu.vhd:271:19 */
  assign n2008 = n1999 ? sr : n2000;
  /*# cupu_fpu.vhd:271:19 */
  assign n2010 = n1999 ? 32'b00000000000000000000000000000000 : res_r;
  /*# cupu_fpu.vhd:270:17 */
  assign n2012 = opn == 4'b0000;
  /*# cupu_fpu.vhd:281:28 */
  assign n2014 = $unsigned(a_exp) >= $unsigned(8'b10011110);
  /*# cupu_fpu.vhd:283:31 */
  assign n2016 = $unsigned(a_exp) < $unsigned(8'b01111110);
  /*# cupu_fpu.vhd:286:41 */
  assign n2018 = {a_m, 8'b00000000};
  /*# cupu_fpu.vhd:286:30 */
  assign n2019 = {34'b0, n2018};  // uext
  /*# cupu_fpu.vhd:287:50 */
  assign n2021 = 8'b10011110 - a_exp;
  /*# cupu_fpu.vhd:283:19 */
  assign n2024 = n2016 ? 5'b11000 : 5'b00100;
  /*# cupu_fpu.vhd:283:19 */
  assign n2025 = n2016 ? x : n2019;
  /*# cupu_fpu.vhd:283:19 */
  assign n2026 = n2016 ? cnt : n2021;
  /*# cupu_fpu.vhd:283:19 */
  assign n2028 = n2016 ? 32'b00000000000000000000000000000000 : res_r;
  /*# cupu_fpu.vhd:281:19 */
  assign n2030 = n2014 ? 5'b11000 : n2024;
  /*# cupu_fpu.vhd:281:19 */
  assign n2031 = n2014 ? x : n2025;
  /*# cupu_fpu.vhd:281:19 */
  assign n2032 = n2014 ? cnt : n2026;
  /*# cupu_fpu.vhd:281:19 */
  assign n2034 = n2014 ? 32'b10000000000000000000000000000000 : n2028;
  /*# cupu_fpu.vhd:280:17 */
  assign n2036 = opn == 4'b0001;
  /*# cupu_fpu.vhd:292:34 */
  assign n2037 = a_nan | b_nan;
  /*# cupu_fpu.vhd:292:65 */
  assign n2038 = b_inf & a_inf;
  /*# cupu_fpu.vhd:292:88 */
  assign n2039 = sa != sbe;
  /*# cupu_fpu.vhd:292:81 */
  assign n2040 = n2039 & n2038;
  /*# cupu_fpu.vhd:292:49 */
  assign n2041 = n2037 | n2040;
  /*# cupu_fpu.vhd:295:36 */
  assign n2042 = a[30:0]; // extract
  /*# cupu_fpu.vhd:295:33 */
  assign n2043 = {sa, n2042};
  /*# cupu_fpu.vhd:297:37 */
  assign n2044 = b[30:0]; // extract
  /*# cupu_fpu.vhd:297:34 */
  assign n2045 = {sbe, n2044};
  /*# cupu_fpu.vhd:299:43 */
  assign n2046 = a[30:0]; // extract
  /*# cupu_fpu.vhd:299:71 */
  assign n2047 = b[30:0]; // extract
  /*# cupu_fpu.vhd:299:58 */
  assign n2048 = $unsigned(n2046) >= $unsigned(n2047);
  /*# cupu_fpu.vhd:305:33 */
  assign n2049 = {{21{a_e[10]}}, a_e}; // sext
  /*# cupu_fpu.vhd:305:33 */
  assign n2051 = n2049 + 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:305:29 */
  assign n2052 = n2051[10:0];  // trunc
  /*# cupu_fpu.vhd:307:33 */
  assign n2053 = {{21{a_e[10]}}, a_e}; // sext
  /*# cupu_fpu.vhd:307:33 */
  assign n2054 = {{21{b_e[10]}}, b_e}; // sext
  /*# cupu_fpu.vhd:307:33 */
  assign n2055 = n2053 - n2054;
  /*# cupu_fpu.vhd:307:23 */
  assign n2056 = n2055[10:0];  // trunc
  /*# cupu_fpu.vhd:311:33 */
  assign n2057 = {{21{b_e[10]}}, b_e}; // sext
  /*# cupu_fpu.vhd:311:33 */
  assign n2059 = n2057 + 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:311:29 */
  assign n2060 = n2059[10:0];  // trunc
  /*# cupu_fpu.vhd:313:33 */
  assign n2061 = {{21{b_e[10]}}, b_e}; // sext
  /*# cupu_fpu.vhd:313:33 */
  assign n2062 = {{21{a_e[10]}}, a_e}; // sext
  /*# cupu_fpu.vhd:313:33 */
  assign n2063 = n2061 - n2062;
  /*# cupu_fpu.vhd:313:23 */
  assign n2064 = n2063[10:0];  // trunc
  /*# cupu_fpu.vhd:302:21 */
  assign n2065 = n2048 ? a_m : b_m;
  /*# cupu_fpu.vhd:75:10 */
  assign n2067 = n2066[65]; // extract
  /*# cupu_fpu.vhd:75:10 */
  assign n2068 = n2066[40:0]; // extract
  /*# cupu_fpu.vhd:302:21 */
  assign n2069 = n2048 ? b_m : a_m;
  /*# cupu_fpu.vhd:75:13 */
  assign n2071 = n2070[65]; // extract
  /*# cupu_fpu.vhd:75:13 */
  assign n2072 = n2070[40:0]; // extract
  /*# cupu_fpu.vhd:302:21 */
  assign n2073 = n2048 ? n2052 : n2060;
  /*# cupu_fpu.vhd:302:21 */
  assign n2074 = n2048 ? sa : sbe;
  /*# cupu_fpu.vhd:302:21 */
  assign n2075 = n2048 ? n2056 : n2064;
  /*# cupu_fpu.vhd:315:26 */
  assign n2076 = {{21{n2075[10]}}, n2075}; // sext
  /*# cupu_fpu.vhd:315:26 */
  assign n2078 = $signed(n2076) > $signed(32'b00000000000000000000000000110010);
  /*# cupu_fpu.vhd:315:21 */
  assign n2080 = n2078 ? 11'b00000110010 : n2075;
  /*# cupu_fpu.vhd:318:31 */
  assign n2082 = n2080[7:0];  // trunc
  /*# cupu_fpu.vhd:319:34 */
  assign n2083 = sa ^ sbe;
  /*# cupu_fpu.vhd:296:19 */
  assign n2086 = b_inf ? 5'b11000 : 5'b00010;
  /*# cupu_fpu.vhd:296:19 */
  assign n2087 = {n2067, n2065, n2068};
  /*# cupu_fpu.vhd:296:19 */
  assign n2088 = b_inf ? r : n2087;
  /*# cupu_fpu.vhd:296:19 */
  assign n2089 = {n2071, n2069, n2072};
  /*# cupu_fpu.vhd:296:19 */
  assign n2090 = b_inf ? x : n2089;
  /*# cupu_fpu.vhd:296:19 */
  assign n2091 = b_inf ? er : n2073;
  /*# cupu_fpu.vhd:296:19 */
  assign n2092 = b_inf ? sr : n2074;
  /*# cupu_fpu.vhd:296:19 */
  assign n2093 = b_inf ? effsub : n2083;
  /*# cupu_fpu.vhd:296:19 */
  assign n2094 = b_inf ? cnt : n2082;
  /*# cupu_fpu.vhd:296:19 */
  assign n2095 = b_inf ? n2045 : res_r;
  /*# cupu_fpu.vhd:294:19 */
  assign n2099 = a_inf ? 5'b11000 : n2086;
  /*# cupu_fpu.vhd:294:19 */
  assign n2100 = a_inf ? r : n2088;
  /*# cupu_fpu.vhd:294:19 */
  assign n2101 = a_inf ? x : n2090;
  /*# cupu_fpu.vhd:294:19 */
  assign n2102 = a_inf ? er : n2091;
  /*# cupu_fpu.vhd:294:19 */
  assign n2103 = a_inf ? sr : n2092;
  /*# cupu_fpu.vhd:294:19 */
  assign n2104 = a_inf ? effsub : n2093;
  /*# cupu_fpu.vhd:294:19 */
  assign n2105 = a_inf ? cnt : n2094;
  /*# cupu_fpu.vhd:294:19 */
  assign n2106 = a_inf ? n2043 : n2095;
  /*# cupu_fpu.vhd:292:19 */
  assign n2110 = n2041 ? 5'b11000 : n2099;
  /*# cupu_fpu.vhd:292:19 */
  assign n2111 = n2041 ? r : n2100;
  /*# cupu_fpu.vhd:292:19 */
  assign n2112 = n2041 ? x : n2101;
  /*# cupu_fpu.vhd:292:19 */
  assign n2113 = n2041 ? er : n2102;
  /*# cupu_fpu.vhd:292:19 */
  assign n2114 = n2041 ? sr : n2103;
  /*# cupu_fpu.vhd:292:19 */
  assign n2115 = n2041 ? effsub : n2104;
  /*# cupu_fpu.vhd:292:19 */
  assign n2116 = n2041 ? cnt : n2105;
  /*# cupu_fpu.vhd:292:19 */
  assign n2118 = n2041 ? 32'b01111111110000000000000000000000 : n2106;
  /*# cupu_fpu.vhd:291:17 */
  assign n2122 = opn == 4'b0010;
  /*# cupu_fpu.vhd:291:30 */
  assign n2124 = opn == 4'b0011;
  /*# cupu_fpu.vhd:291:30 */
  assign n2125 = n2122 | n2124;
  /*# cupu_fpu.vhd:324:28 */
  assign n2126 = sa ^ sb;
  /*# cupu_fpu.vhd:325:34 */
  assign n2127 = a_nan | b_nan;
  /*# cupu_fpu.vhd:325:65 */
  assign n2128 = b_zero & a_inf;
  /*# cupu_fpu.vhd:325:49 */
  assign n2129 = n2127 | n2128;
  /*# cupu_fpu.vhd:325:100 */
  assign n2130 = b_inf & a_zero;
  /*# cupu_fpu.vhd:325:83 */
  assign n2131 = n2129 | n2130;
  /*# cupu_fpu.vhd:327:37 */
  assign n2132 = a_inf | b_inf;
  /*# cupu_fpu.vhd:328:34 */
  assign n2133 = sa ^ sb;
  /*# cupu_fpu.vhd:328:42 */
  assign n2135 = {n2133, 31'b1111111100000000000000000000000};
  /*# cupu_fpu.vhd:329:38 */
  assign n2136 = a_zero | b_zero;
  /*# cupu_fpu.vhd:330:34 */
  assign n2137 = sa ^ sb;
  /*# cupu_fpu.vhd:330:42 */
  assign n2139 = {n2137, 31'b0000000000000000000000000000000};
  /*# cupu_fpu.vhd:329:19 */
  assign n2142 = n2136 ? 5'b11000 : 5'b00001;
  /*# cupu_fpu.vhd:329:19 */
  assign n2143 = n2136 ? n2139 : res_r;
  /*# cupu_fpu.vhd:327:19 */
  assign n2145 = n2132 ? 5'b11000 : n2142;
  /*# cupu_fpu.vhd:327:19 */
  assign n2146 = n2132 ? n2135 : n2143;
  /*# cupu_fpu.vhd:325:19 */
  assign n2148 = n2131 ? 5'b11000 : n2145;
  /*# cupu_fpu.vhd:325:19 */
  assign n2150 = n2131 ? 32'b01111111110000000000000000000000 : n2146;
  /*# cupu_fpu.vhd:323:17 */
  assign n2152 = opn == 4'b0100;
  /*# cupu_fpu.vhd:336:28 */
  assign n2153 = sa ^ sb;
  /*# cupu_fpu.vhd:337:34 */
  assign n2154 = a_nan | b_nan;
  /*# cupu_fpu.vhd:337:65 */
  assign n2155 = b_inf & a_inf;
  /*# cupu_fpu.vhd:337:49 */
  assign n2156 = n2154 | n2155;
  /*# cupu_fpu.vhd:337:99 */
  assign n2157 = b_zero & a_zero;
  /*# cupu_fpu.vhd:337:82 */
  assign n2158 = n2156 | n2157;
  /*# cupu_fpu.vhd:339:37 */
  assign n2159 = a_inf | b_zero;
  /*# cupu_fpu.vhd:340:34 */
  assign n2160 = sa ^ sb;
  /*# cupu_fpu.vhd:340:42 */
  assign n2162 = {n2160, 31'b1111111100000000000000000000000};
  /*# cupu_fpu.vhd:341:38 */
  assign n2163 = a_zero | b_inf;
  /*# cupu_fpu.vhd:342:34 */
  assign n2164 = sa ^ sb;
  /*# cupu_fpu.vhd:342:42 */
  assign n2166 = {n2164, 31'b0000000000000000000000000000000};
  /*# cupu_fpu.vhd:341:19 */
  assign n2169 = n2163 ? 5'b11000 : 5'b00001;
  /*# cupu_fpu.vhd:341:19 */
  assign n2170 = n2163 ? n2166 : res_r;
  /*# cupu_fpu.vhd:339:19 */
  assign n2172 = n2159 ? 5'b11000 : n2169;
  /*# cupu_fpu.vhd:339:19 */
  assign n2173 = n2159 ? n2162 : n2170;
  /*# cupu_fpu.vhd:337:19 */
  assign n2175 = n2158 ? 5'b11000 : n2172;
  /*# cupu_fpu.vhd:337:19 */
  assign n2177 = n2158 ? 32'b01111111110000000000000000000000 : n2173;
  /*# cupu_fpu.vhd:335:17 */
  assign n2179 = opn == 4'b0101;
  /*# cupu_fpu.vhd:350:58 */
  assign n2180 = ~a_zero;
  /*# cupu_fpu.vhd:350:47 */
  assign n2181 = n2180 & sa;
  /*# cupu_fpu.vhd:350:34 */
  assign n2182 = a_nan | n2181;
  /*# cupu_fpu.vhd:352:38 */
  assign n2183 = a_zero | a_inf;
  /*# cupu_fpu.vhd:352:19 */
  assign n2186 = n2183 ? 5'b11000 : 5'b00001;
  /*# cupu_fpu.vhd:352:19 */
  assign n2187 = n2183 ? a : res_r;
  /*# cupu_fpu.vhd:350:19 */
  assign n2189 = n2182 ? 5'b11000 : n2186;
  /*# cupu_fpu.vhd:350:19 */
  assign n2191 = n2182 ? 32'b01111111110000000000000000000000 : n2187;
  /*# cupu_fpu.vhd:347:17 */
  assign n2193 = opn == 4'b0110;
  /*# cupu_fpu.vhd:359:34 */
  assign n2194 = a_nan | a_inf;
  /*# cupu_fpu.vhd:361:31 */
  assign n2196 = $unsigned(a_exp) < $unsigned(8'b01110011);
  /*# cupu_fpu.vhd:362:28 */
  assign n2197 = {28'b0, opn};  // uext
  /*# cupu_fpu.vhd:362:28 */
  assign n2199 = n2197 == 32'b00000000000000000000000000001000;
  /*# cupu_fpu.vhd:362:21 */
  assign n2201 = n2199 ? 32'b00111111100000000000000000000000 : a;
  /*# cupu_fpu.vhd:367:31 */
  assign n2203 = $unsigned(a_exp) < $unsigned(8'b01111110);
  /*# cupu_fpu.vhd:368:30 */
  assign n2204 = {42'b0, a_m};  // uext
  /*# cupu_fpu.vhd:369:36 */
  assign n2206 = a_exp - 8'b01011000;
  /*# cupu_fpu.vhd:374:36 */
  assign n2208 = a_exp - 8'b00111010;
  /*# cupu_fpu.vhd:367:19 */
  assign n2211 = n2203 ? 5'b01010 : 5'b01011;
  /*# cupu_fpu.vhd:367:19 */
  assign n2212 = n2203 ? n2204 : z;
  /*# cupu_fpu.vhd:367:19 */
  assign n2214 = n2203 ? w : 92'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:367:19 */
  assign n2215 = n2203 ? n2206 : n2208;
  /*# cupu_fpu.vhd:367:19 */
  assign n2217 = n2203 ? 2'b00 : quad;
  /*# cupu_fpu.vhd:361:19 */
  assign n2219 = n2196 ? 5'b11000 : n2211;
  /*# cupu_fpu.vhd:361:19 */
  assign n2220 = n2196 ? z : n2212;
  /*# cupu_fpu.vhd:361:19 */
  assign n2221 = n2196 ? w : n2214;
  /*# cupu_fpu.vhd:361:19 */
  assign n2222 = n2196 ? cnt : n2215;
  /*# cupu_fpu.vhd:361:19 */
  assign n2223 = n2196 ? quad : n2217;
  /*# cupu_fpu.vhd:361:19 */
  assign n2224 = n2196 ? n2201 : res_r;
  /*# cupu_fpu.vhd:359:19 */
  assign n2226 = n2194 ? 5'b11000 : n2219;
  /*# cupu_fpu.vhd:359:19 */
  assign n2227 = n2194 ? z : n2220;
  /*# cupu_fpu.vhd:359:19 */
  assign n2228 = n2194 ? w : n2221;
  /*# cupu_fpu.vhd:359:19 */
  assign n2229 = n2194 ? cnt : n2222;
  /*# cupu_fpu.vhd:359:19 */
  assign n2230 = n2194 ? quad : n2223;
  /*# cupu_fpu.vhd:359:19 */
  assign n2232 = n2194 ? 32'b01111111110000000000000000000000 : n2224;
  /*# cupu_fpu.vhd:358:17 */
  assign n2234 = opn == 4'b0111;
  /*# cupu_fpu.vhd:358:29 */
  assign n2236 = opn == 4'b1000;
  /*# cupu_fpu.vhd:358:29 */
  assign n2237 = n2234 | n2236;
  /*# cupu_fpu.vhd:358:38 */
  assign n2239 = opn == 4'b1001;
  /*# cupu_fpu.vhd:358:38 */
  assign n2240 = n2237 | n2239;
  /*# cupu_fpu.vhd:269:15 */
  assign n2241 = {n2240, n2193, n2179, n2152, n2125, n2036, n2012};
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2243 = n2226;
      7'b0100000: n2243 = n2189;
      7'b0010000: n2243 = n2175;
      7'b0001000: n2243 = n2148;
      7'b0000100: n2243 = n2110;
      7'b0000010: n2243 = n2030;
      7'b0000001: n2243 = n2004;
      default: n2243 = 5'b11000;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2245 = r;
      7'b0100000: n2245 = r;
      7'b0010000: n2245 = r;
      7'b0001000: n2245 = r;
      7'b0000100: n2245 = n2111;
      7'b0000010: n2245 = r;
      7'b0000001: n2245 = n2005;
      default: n2245 = r;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2246 = x;
      7'b0100000: n2246 = x;
      7'b0010000: n2246 = x;
      7'b0001000: n2246 = x;
      7'b0000100: n2246 = n2112;
      7'b0000010: n2246 = n2031;
      7'b0000001: n2246 = x;
      default: n2246 = x;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2247 = n2227;
      7'b0100000: n2247 = z;
      7'b0010000: n2247 = z;
      7'b0001000: n2247 = z;
      7'b0000100: n2247 = z;
      7'b0000010: n2247 = z;
      7'b0000001: n2247 = z;
      default: n2247 = z;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2248 = n2228;
      7'b0100000: n2248 = w;
      7'b0010000: n2248 = w;
      7'b0001000: n2248 = w;
      7'b0000100: n2248 = w;
      7'b0000010: n2248 = w;
      7'b0000001: n2248 = w;
      default: n2248 = w;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2250 = b_m;
      7'b0100000: n2250 = 24'b100000000000000000000000;
      7'b0010000: n2250 = b_m;
      7'b0001000: n2250 = b_m;
      7'b0000100: n2250 = b_m;
      7'b0000010: n2250 = b_m;
      7'b0000001: n2250 = b_m;
      default: n2250 = b_m;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2251 = er;
      7'b0100000: n2251 = er;
      7'b0010000: n2251 = er;
      7'b0001000: n2251 = er;
      7'b0000100: n2251 = n2113;
      7'b0000010: n2251 = er;
      7'b0000001: n2251 = n2007;
      default: n2251 = er;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2253 = sr;
      7'b0100000: n2253 = 1'b0;
      7'b0010000: n2253 = n2153;
      7'b0001000: n2253 = n2126;
      7'b0000100: n2253 = n2114;
      7'b0000010: n2253 = sr;
      7'b0000001: n2253 = n2008;
      default: n2253 = sr;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2254 = effsub;
      7'b0100000: n2254 = effsub;
      7'b0010000: n2254 = effsub;
      7'b0001000: n2254 = effsub;
      7'b0000100: n2254 = n2115;
      7'b0000010: n2254 = effsub;
      7'b0000001: n2254 = effsub;
      default: n2254 = effsub;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2255 = n2229;
      7'b0100000: n2255 = cnt;
      7'b0010000: n2255 = cnt;
      7'b0001000: n2255 = cnt;
      7'b0000100: n2255 = n2116;
      7'b0000010: n2255 = n2032;
      7'b0000001: n2255 = cnt;
      default: n2255 = cnt;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2256 = n2230;
      7'b0100000: n2256 = quad;
      7'b0010000: n2256 = quad;
      7'b0001000: n2256 = quad;
      7'b0000100: n2256 = quad;
      7'b0000010: n2256 = quad;
      7'b0000001: n2256 = quad;
      default: n2256 = quad;
    endcase
  /*# cupu_fpu.vhd:269:15 */
  always @*
    case (n2241)
      7'b1000000: n2258 = n2232;
      7'b0100000: n2258 = n2191;
      7'b0010000: n2258 = n2177;
      7'b0001000: n2258 = n2150;
      7'b0000100: n2258 = n2118;
      7'b0000010: n2258 = n2034;
      7'b0000001: n2258 = n2010;
      default: n2258 = 32'b01111111110000000000000000000000;
    endcase
  /*# cupu_fpu.vhd:267:13 */
  assign n2261 = start ? n2243 : state;
  /*# cupu_fpu.vhd:267:13 */
  assign n2262 = start ? n2245 : r;
  /*# cupu_fpu.vhd:267:13 */
  assign n2263 = start ? n2246 : x;
  /*# cupu_fpu.vhd:267:13 */
  assign n2264 = start ? n2247 : z;
  /*# cupu_fpu.vhd:267:13 */
  assign n2265 = start ? n2248 : w;
  /*# cupu_fpu.vhd:267:13 */
  assign n2266 = start ? n2250 : b_m;
  /*# cupu_fpu.vhd:267:13 */
  assign n2267 = start ? n2251 : er;
  /*# cupu_fpu.vhd:267:13 */
  assign n2268 = start ? n2253 : sr;
  /*# cupu_fpu.vhd:267:13 */
  assign n2269 = start ? n2254 : effsub;
  /*# cupu_fpu.vhd:267:13 */
  assign n2270 = start ? n2255 : cnt;
  /*# cupu_fpu.vhd:267:13 */
  assign n2271 = start ? n2256 : quad;
  /*# cupu_fpu.vhd:267:13 */
  assign n2272 = start ? n2258 : res_r;
  /*# cupu_fpu.vhd:260:11 */
  assign n2276 = state == 5'b00000;
  /*# cupu_fpu.vhd:386:18 */
  assign n2277 = ma[23]; // extract
  /*# cupu_fpu.vhd:386:23 */
  assign n2278 = ~n2277;
  /*# cupu_fpu.vhd:387:23 */
  assign n2279 = ma[22:0]; // extract
  /*# cupu_fpu.vhd:387:37 */
  assign n2281 = {n2279, 1'b0};
  /*# cupu_fpu.vhd:388:24 */
  assign n2282 = {{21{ea[10]}}, ea}; // sext
  /*# cupu_fpu.vhd:388:24 */
  assign n2284 = n2282 - 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:388:21 */
  assign n2285 = n2284[10:0];  // trunc
  /*# cupu_fpu.vhd:389:21 */
  assign n2286 = mb[23]; // extract
  /*# cupu_fpu.vhd:389:26 */
  assign n2287 = ~n2286;
  /*# cupu_fpu.vhd:390:23 */
  assign n2288 = mb[22:0]; // extract
  /*# cupu_fpu.vhd:390:37 */
  assign n2290 = {n2288, 1'b0};
  /*# cupu_fpu.vhd:391:24 */
  assign n2291 = {{21{eb[10]}}, eb}; // sext
  /*# cupu_fpu.vhd:391:24 */
  assign n2293 = n2291 - 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:391:21 */
  assign n2294 = n2293[10:0];  // trunc
  /*# cupu_fpu.vhd:396:28 */
  assign n2295 = {42'b0, ma};  // uext
  /*# cupu_fpu.vhd:394:17 */
  assign n2297 = opn == 4'b0100;
  /*# cupu_fpu.vhd:400:38 */
  assign n2299 = {ma, 10'b0000000000};
  /*# cupu_fpu.vhd:400:28 */
  assign n2300 = {32'b0, n2299};  // uext
  /*# cupu_fpu.vhd:401:38 */
  assign n2302 = {mb, 10'b0000000000};
  /*# cupu_fpu.vhd:401:28 */
  assign n2303 = {32'b0, n2302};  // uext
  /*# cupu_fpu.vhd:403:31 */
  assign n2304 = {{21{ea[10]}}, ea}; // sext
  /*# cupu_fpu.vhd:403:31 */
  assign n2305 = {{21{eb[10]}}, eb}; // sext
  /*# cupu_fpu.vhd:403:31 */
  assign n2306 = n2304 - n2305;
  /*# cupu_fpu.vhd:403:36 */
  assign n2308 = n2306 + 32'b00000000000000000000000000100110;
  /*# cupu_fpu.vhd:403:28 */
  assign n2309 = n2308[10:0];  // trunc
  /*# cupu_fpu.vhd:399:17 */
  assign n2311 = opn == 4'b0101;
  /*# cupu_fpu.vhd:407:25 */
  assign n2312 = {{21{ea[10]}}, ea}; // sext
  /*# cupu_fpu.vhd:407:25 */
  assign n2313 = n2312[0]; // extract
  /*# cupu_fpu.vhd:407:25 */
  assign n2314 = {31'b0, n2313};  // uext
  /*# cupu_fpu.vhd:407:31 */
  assign n2316 = n2314 == 32'b00000000000000000000000000000000;
  /*# cupu_fpu.vhd:408:38 */
  assign n2317 = {42'b0, ma};  // uext
  /*# cupu_fpu.vhd:408:27 */
  assign n2319 = n2317 << 31'b0000000000000000000000000011111;
  /*# cupu_fpu.vhd:409:30 */
  assign n2320 = {{21{ea[10]}}, ea}; // sext
  /*# cupu_fpu.vhd:409:30 */
  assign n2322 = $signed(n2320) / $signed(32'b00000000000000000000000000000010); // sdiv
  /*# cupu_fpu.vhd:409:34 */
  assign n2324 = n2322 + 32'b00000000000000000000000000100110;
  /*# cupu_fpu.vhd:409:27 */
  assign n2325 = n2324[10:0];  // trunc
  /*# cupu_fpu.vhd:411:38 */
  assign n2326 = {42'b0, ma};  // uext
  /*# cupu_fpu.vhd:411:27 */
  assign n2328 = n2326 << 31'b0000000000000000000000000100000;
  /*# cupu_fpu.vhd:412:31 */
  assign n2329 = {{21{ea[10]}}, ea}; // sext
  /*# cupu_fpu.vhd:412:31 */
  assign n2331 = n2329 - 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:412:36 */
  assign n2333 = $signed(n2331) / $signed(32'b00000000000000000000000000000010); // sdiv
  /*# cupu_fpu.vhd:412:40 */
  assign n2335 = n2333 + 32'b00000000000000000000000000100110;
  /*# cupu_fpu.vhd:412:27 */
  assign n2336 = n2335[10:0];  // trunc
  /*# cupu_fpu.vhd:407:19 */
  assign n2337 = n2316 ? n2319 : n2328;
  /*# cupu_fpu.vhd:407:19 */
  assign n2338 = n2316 ? n2325 : n2336;
  /*# cupu_fpu.vhd:393:15 */
  assign n2339 = {n2311, n2297};
  /*# cupu_fpu.vhd:393:15 */
  always @*
    case (n2339)
      2'b10: n2343 = 5'b01000;
      2'b01: n2343 = 5'b00111;
      default: n2343 = 5'b01001;
    endcase
  /*# cupu_fpu.vhd:393:15 */
  always @*
    case (n2339)
      2'b10: n2345 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
      2'b01: n2345 = r;
      default: n2345 = r;
    endcase
  /*# cupu_fpu.vhd:393:15 */
  always @*
    case (n2339)
      2'b10: n2347 = n2300;
      2'b01: n2347 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
      default: n2347 = n2337;
    endcase
  /*# cupu_fpu.vhd:393:15 */
  always @*
    case (n2339)
      2'b10: n2349 = n2303;
      2'b01: n2349 = n2295;
      default: n2349 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
    endcase
  /*# cupu_fpu.vhd:393:15 */
  always @*
    case (n2339)
      2'b10: n2351 = z;
      2'b01: n2351 = z;
      default: n2351 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
    endcase
  /*# cupu_fpu.vhd:393:15 */
  always @*
    case (n2339)
      2'b10: n2352 = n2309;
      2'b01: n2352 = er;
      default: n2352 = n2338;
    endcase
  /*# cupu_fpu.vhd:393:15 */
  always @*
    case (n2339)
      2'b10: n2356 = 8'b00011100;
      2'b01: n2356 = 8'b00011000;
      default: n2356 = 8'b00011100;
    endcase
  /*# cupu_fpu.vhd:389:13 */
  assign n2357 = n2287 ? state : n2343;
  /*# cupu_fpu.vhd:389:13 */
  assign n2358 = n2287 ? r : n2345;
  /*# cupu_fpu.vhd:389:13 */
  assign n2359 = n2287 ? x : n2347;
  /*# cupu_fpu.vhd:389:13 */
  assign n2360 = n2287 ? y : n2349;
  /*# cupu_fpu.vhd:389:13 */
  assign n2361 = n2287 ? z : n2351;
  /*# cupu_fpu.vhd:389:13 */
  assign n2362 = n2287 ? n2290 : mb;
  /*# cupu_fpu.vhd:389:13 */
  assign n2363 = n2287 ? n2294 : eb;
  /*# cupu_fpu.vhd:389:13 */
  assign n2364 = n2287 ? er : n2352;
  /*# cupu_fpu.vhd:389:13 */
  assign n2365 = n2287 ? cnt : n2356;
  /*# cupu_fpu.vhd:386:13 */
  assign n2366 = n2278 ? state : n2357;
  /*# cupu_fpu.vhd:386:13 */
  assign n2367 = n2278 ? r : n2358;
  /*# cupu_fpu.vhd:386:13 */
  assign n2368 = n2278 ? x : n2359;
  /*# cupu_fpu.vhd:386:13 */
  assign n2369 = n2278 ? y : n2360;
  /*# cupu_fpu.vhd:386:13 */
  assign n2370 = n2278 ? z : n2361;
  /*# cupu_fpu.vhd:386:13 */
  assign n2371 = n2278 ? n2281 : ma;
  /*# cupu_fpu.vhd:386:13 */
  assign n2372 = n2278 ? mb : n2362;
  /*# cupu_fpu.vhd:386:13 */
  assign n2373 = n2278 ? n2285 : ea;
  /*# cupu_fpu.vhd:386:13 */
  assign n2374 = n2278 ? eb : n2363;
  /*# cupu_fpu.vhd:386:13 */
  assign n2375 = n2278 ? er : n2364;
  /*# cupu_fpu.vhd:386:13 */
  assign n2376 = n2278 ? cnt : n2365;
  /*# cupu_fpu.vhd:384:11 */
  assign n2378 = state == 5'b00001;
  /*# cupu_fpu.vhd:424:20 */
  assign n2380 = cnt == 8'b00000000;
  /*# cupu_fpu.vhd:427:29 */
  assign n2381 = x[65:2]; // extract
  /*# cupu_fpu.vhd:427:26 */
  assign n2383 = {1'b0, n2381};
  /*# cupu_fpu.vhd:427:47 */
  assign n2384 = x[1]; // extract
  /*# cupu_fpu.vhd:427:55 */
  assign n2385 = x[0]; // extract
  /*# cupu_fpu.vhd:427:51 */
  assign n2386 = n2384 | n2385;
  /*# cupu_fpu.vhd:427:43 */
  assign n2387 = {n2383, n2386};
  /*# cupu_fpu.vhd:428:26 */
  assign n2389 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:424:13 */
  assign n2391 = n2380 ? 5'b00011 : state;
  /*# cupu_fpu.vhd:424:13 */
  assign n2392 = n2380 ? x : n2387;
  /*# cupu_fpu.vhd:424:13 */
  assign n2393 = n2380 ? cnt : n2389;
  /*# cupu_fpu.vhd:422:11 */
  assign n2395 = state == 5'b00010;
  /*# cupu_fpu.vhd:432:23 */
  assign n2396 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:433:21 */
  assign n2397 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:433:35 */
  assign n2399 = n2397 == 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:434:24 */
  assign n2400 = sa & sbe;
  /*# cupu_fpu.vhd:433:13 */
  assign n2401 = n2399 ? n2400 : sr;
  /*# cupu_fpu.vhd:431:11 */
  assign n2403 = state == 5'b00011;
  /*# cupu_fpu.vhd:440:20 */
  assign n2405 = cnt == 8'b00000000;
  /*# cupu_fpu.vhd:443:29 */
  assign n2406 = x[65:1]; // extract
  /*# cupu_fpu.vhd:443:26 */
  assign n2408 = {1'b0, n2406};
  /*# cupu_fpu.vhd:444:23 */
  assign n2409 = x[0]; // extract
  /*# cupu_fpu.vhd:445:26 */
  assign n2411 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:440:13 */
  assign n2413 = n2405 ? 5'b00101 : state;
  /*# cupu_fpu.vhd:440:13 */
  assign n2414 = n2405 ? x : n2408;
  /*# cupu_fpu.vhd:440:13 */
  assign n2415 = n2405 ? stk : n2409;
  /*# cupu_fpu.vhd:440:13 */
  assign n2416 = n2405 ? cnt : n2411;
  /*# cupu_fpu.vhd:439:11 */
  assign n2418 = state == 5'b00100;
  /*# cupu_fpu.vhd:449:27 */
  assign n2419 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:448:11 */
  assign n2421 = state == 5'b00101;
  /*# cupu_fpu.vhd:453:44 */
  assign n2422 = add_s[31:0]; // extract
  /*# cupu_fpu.vhd:452:11 */
  assign n2424 = state == 5'b00110;
  /*# cupu_fpu.vhd:459:20 */
  assign n2426 = cnt == 8'b00000000;
  /*# cupu_fpu.vhd:461:27 */
  assign n2427 = {{21{ea[10]}}, ea}; // sext
  /*# cupu_fpu.vhd:461:27 */
  assign n2428 = {{21{eb[10]}}, eb}; // sext
  /*# cupu_fpu.vhd:461:27 */
  assign n2429 = n2427 + n2428;
  /*# cupu_fpu.vhd:461:32 */
  assign n2431 = n2429 + 32'b00000000000000000000000000010011;
  /*# cupu_fpu.vhd:461:24 */
  assign n2432 = n2431[10:0];  // trunc
  /*# cupu_fpu.vhd:464:38 */
  assign n2433 = add_s[24:0]; // extract
  /*# cupu_fpu.vhd:464:55 */
  assign n2434 = x[23:1]; // extract
  /*# cupu_fpu.vhd:464:52 */
  assign n2435 = {n2433, n2434};
  /*# cupu_fpu.vhd:465:29 */
  assign n2436 = y[65:1]; // extract
  /*# cupu_fpu.vhd:465:26 */
  assign n2438 = {1'b0, n2436};
  /*# cupu_fpu.vhd:466:26 */
  assign n2440 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:459:13 */
  assign n2442 = n2426 ? 5'b10110 : state;
  /*# cupu_fpu.vhd:459:13 */
  assign n2443 = n2426 ? x : r;
  /*# cupu_fpu.vhd:75:13 */
  assign n2444 = x[47:0]; // extract
  /*# cupu_fpu.vhd:459:13 */
  assign n2445 = n2426 ? n2444 : n2435;
  /*# cupu_fpu.vhd:459:13 */
  assign n2446 = n2426 ? y : n2438;
  /*# cupu_fpu.vhd:459:13 */
  assign n2447 = n2426 ? n2432 : er;
  /*# cupu_fpu.vhd:459:13 */
  assign n2448 = n2426 ? cnt : n2440;
  /*# cupu_fpu.vhd:457:11 */
  assign n2450 = state == 5'b00111;
  /*# cupu_fpu.vhd:471:20 */
  assign n2452 = cnt == 8'b00000000;
  /*# cupu_fpu.vhd:472:20 */
  assign n2454 = x != 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:471:13 */
  assign n2456 = n2472 ? 1'b1 : stk;
  /*# cupu_fpu.vhd:477:21 */
  assign n2457 = r[64:0]; // extract
  /*# cupu_fpu.vhd:477:35 */
  assign n2458 = {n2457, add_ge};
  /*# cupu_fpu.vhd:479:27 */
  assign n2459 = add_s[64:0]; // extract
  /*# cupu_fpu.vhd:479:41 */
  assign n2461 = {n2459, 1'b0};
  /*# cupu_fpu.vhd:481:23 */
  assign n2462 = x[64:0]; // extract
  /*# cupu_fpu.vhd:481:37 */
  assign n2464 = {n2462, 1'b0};
  /*# cupu_fpu.vhd:478:15 */
  assign n2465 = add_ge ? n2461 : n2464;
  /*# cupu_fpu.vhd:483:26 */
  assign n2467 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:471:13 */
  assign n2469 = n2452 ? 5'b10110 : state;
  /*# cupu_fpu.vhd:471:13 */
  assign n2470 = n2452 ? r : n2458;
  /*# cupu_fpu.vhd:471:13 */
  assign n2471 = n2452 ? x : n2465;
  /*# cupu_fpu.vhd:471:13 */
  assign n2472 = n2454 & n2452;
  /*# cupu_fpu.vhd:471:13 */
  assign n2473 = n2452 ? cnt : n2467;
  /*# cupu_fpu.vhd:469:11 */
  assign n2475 = state == 5'b01000;
  /*# cupu_fpu.vhd:488:20 */
  assign n2477 = cnt == 8'b00000000;
  /*# cupu_fpu.vhd:490:20 */
  assign n2479 = y != 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:488:13 */
  assign n2481 = n2501 ? 1'b1 : stk;
  /*# cupu_fpu.vhd:496:27 */
  assign n2482 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:498:30 */
  assign n2483 = y[31:0]; // extract
  /*# cupu_fpu.vhd:498:47 */
  assign n2484 = x[55:54]; // extract
  /*# cupu_fpu.vhd:498:44 */
  assign n2485 = {n2483, n2484};
  /*# cupu_fpu.vhd:498:22 */
  assign n2486 = {32'b0, n2485};  // uext
  /*# cupu_fpu.vhd:495:15 */
  assign n2487 = add_ge ? n2482 : n2486;
  /*# cupu_fpu.vhd:500:23 */
  assign n2488 = z[64:0]; // extract
  /*# cupu_fpu.vhd:500:37 */
  assign n2489 = {n2488, add_ge};
  /*# cupu_fpu.vhd:501:23 */
  assign n2490 = x[63:0]; // extract
  /*# cupu_fpu.vhd:501:37 */
  assign n2492 = {n2490, 2'b00};
  /*# cupu_fpu.vhd:502:26 */
  assign n2494 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:488:13 */
  assign n2496 = n2477 ? 5'b10110 : state;
  /*# cupu_fpu.vhd:488:13 */
  assign n2497 = n2477 ? z : r;
  /*# cupu_fpu.vhd:488:13 */
  assign n2498 = n2477 ? x : n2492;
  /*# cupu_fpu.vhd:488:13 */
  assign n2499 = n2477 ? y : n2487;
  /*# cupu_fpu.vhd:488:13 */
  assign n2500 = n2477 ? z : n2489;
  /*# cupu_fpu.vhd:488:13 */
  assign n2501 = n2479 & n2477;
  /*# cupu_fpu.vhd:488:13 */
  assign n2502 = n2477 ? cnt : n2494;
  /*# cupu_fpu.vhd:486:11 */
  assign n2504 = state == 5'b01001;
  /*# cupu_fpu.vhd:509:20 */
  assign n2506 = cnt == 8'b00000000;
  /*# cupu_fpu.vhd:512:23 */
  assign n2507 = z[64:0]; // extract
  /*# cupu_fpu.vhd:512:37 */
  assign n2509 = {n2507, 1'b0};
  /*# cupu_fpu.vhd:513:26 */
  assign n2511 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:509:13 */
  assign n2513 = n2506 ? 5'b01111 : state;
  /*# cupu_fpu.vhd:509:13 */
  assign n2514 = n2506 ? z : n2509;
  /*# cupu_fpu.vhd:509:13 */
  assign n2515 = n2506 ? cnt : n2511;
  /*# cupu_fpu.vhd:508:11 */
  assign n2517 = state == 5'b01010;
  /*# cupu_fpu.vhd:519:23 */
  assign n2518 = add_s[24:0]; // extract
  /*# cupu_fpu.vhd:519:40 */
  assign n2519 = w[67:1]; // extract
  /*# cupu_fpu.vhd:519:37 */
  assign n2520 = {n2518, n2519};
  /*# cupu_fpu.vhd:520:18 */
  assign n2521 = {23'b0, a_exp};  // uext
  /*# cupu_fpu.vhd:520:36 */
  assign n2522 = {1'b0, n2521};  // uext
  /*# cupu_fpu.vhd:520:36 */
  assign n2524 = n2522 - 32'b00000000000000000000000010010111;
  /*# cupu_fpu.vhd:520:13 */
  assign n2525 = n2524[10:0];  // trunc
  /*# cupu_fpu.vhd:521:18 */
  assign n2526 = {{21{n2525[10]}}, n2525}; // sext
  /*# cupu_fpu.vhd:521:18 */
  assign n2528 = $signed(n2526) < $signed(32'b00000000000000000000000000000001);
  /*# cupu_fpu.vhd:521:13 */
  assign n2530 = n2528 ? 11'b00000000001 : n2525;
  /*# cupu_fpu.vhd:524:16 */
  assign n2531 = {23'b0, cnt};  // uext
  /*# cupu_fpu.vhd:524:32 */
  assign n2532 = {1'b0, n2531};  // uext
  /*# cupu_fpu.vhd:524:32 */
  assign n2533 = {{21{n2530[10]}}, n2530}; // sext
  /*# cupu_fpu.vhd:524:32 */
  assign n2534 = n2532 == n2533;
  /*# cupu_fpu.vhd:525:24 */
  assign n2536 = $unsigned(a_exp) < $unsigned(8'b10011000);
  /*# cupu_fpu.vhd:526:44 */
  assign n2538 = 8'b10011000 - a_exp;
  /*# cupu_fpu.vhd:525:15 */
  assign n2540 = n2536 ? n2538 : 8'b00000000;
  /*# cupu_fpu.vhd:532:26 */
  assign n2542 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:524:13 */
  assign n2544 = n2534 ? 5'b01100 : state;
  /*# cupu_fpu.vhd:524:13 */
  assign n2545 = n2534 ? n2540 : n2542;
  /*# cupu_fpu.vhd:516:11 */
  assign n2547 = state == 5'b01011;
  /*# cupu_fpu.vhd:536:20 */
  assign n2549 = cnt == 8'b00000000;
  /*# cupu_fpu.vhd:539:29 */
  assign n2550 = w[91:1]; // extract
  /*# cupu_fpu.vhd:539:26 */
  assign n2552 = {1'b0, n2550};
  /*# cupu_fpu.vhd:540:26 */
  assign n2554 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:536:13 */
  assign n2556 = n2549 ? 5'b01101 : state;
  /*# cupu_fpu.vhd:536:13 */
  assign n2557 = n2549 ? w : n2552;
  /*# cupu_fpu.vhd:536:13 */
  assign n2558 = n2549 ? cnt : n2554;
  /*# cupu_fpu.vhd:535:11 */
  assign n2560 = state == 5'b01100;
  /*# cupu_fpu.vhd:545:23 */
  assign n2561 = w[67:66]; // extract
  /*# cupu_fpu.vhd:545:48 */
  assign n2562 = w[65]; // extract
  /*# cupu_fpu.vhd:545:45 */
  assign n2564 = {1'b0, n2562};
  /*# cupu_fpu.vhd:545:38 */
  assign n2565 = n2561 + n2564;
  /*# cupu_fpu.vhd:546:51 */
  assign n2566 = w[65:0]; // extract
  /*# cupu_fpu.vhd:546:31 */
  assign n2568 = $signed(n2566) >>> 31'b0000000000000000000000000000100;
  /*# cupu_fpu.vhd:543:11 */
  assign n2570 = state == 5'b01101;
  /*# cupu_fpu.vhd:553:23 */
  assign n2571 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:554:20 */
  assign n2573 = cnt == 8'b00000000;
  /*# cupu_fpu.vhd:557:26 */
  assign n2575 = cnt - 8'b00000001;
  /*# cupu_fpu.vhd:554:13 */
  assign n2577 = n2573 ? 5'b01111 : state;
  /*# cupu_fpu.vhd:554:13 */
  assign n2578 = n2573 ? cnt : n2575;
  /*# cupu_fpu.vhd:551:11 */
  assign n2580 = state == 5'b01110;
  /*# cupu_fpu.vhd:562:17 */
  assign n2581 = z[65:42]; // extract
  /*# cupu_fpu.vhd:562:32 */
  assign n2583 = n2581 == 24'b000000000000000000000000;
  /*# cupu_fpu.vhd:562:44 */
  assign n2584 = z[65:42]; // extract
  /*# cupu_fpu.vhd:562:39 */
  assign n2585 = ~n2584;
  /*# cupu_fpu.vhd:562:59 */
  assign n2587 = n2585 == 24'b000000000000000000000000;
  /*# cupu_fpu.vhd:562:36 */
  assign n2588 = n2583 | n2587;
  /*# cupu_fpu.vhd:562:13 */
  assign n2591 = n2588 ? 5'b10011 : 5'b10000;
  /*# cupu_fpu.vhd:562:13 */
  assign n2594 = n2588 ? 66'b000100000000000000000000000000000000000000000000000000000000000000 : 66'b000010011011011101001110110110101000010000110101111001011010011010;
  /*# cupu_fpu.vhd:562:13 */
  assign n2596 = n2588 ? z : 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:562:13 */
  assign n2598 = n2588 ? cnt : 8'b00000000;
  /*# cupu_fpu.vhd:560:11 */
  assign n2600 = state == 5'b01111;
  /*# cupu_fpu.vhd:574:36 */
  assign n2601 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:573:11 */
  assign n2603 = state == 5'b10000;
  /*# cupu_fpu.vhd:578:27 */
  assign n2604 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:577:11 */
  assign n2606 = state == 5'b10001;
  /*# cupu_fpu.vhd:582:19 */
  assign n2607 = w[65:0]; // extract
  /*# cupu_fpu.vhd:583:23 */
  assign n2608 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:584:20 */
  assign n2610 = cnt == 8'b00111101;
  /*# cupu_fpu.vhd:587:28 */
  assign n2612 = cnt + 8'b00000001;
  /*# cupu_fpu.vhd:584:13 */
  assign n2615 = n2610 ? 5'b10011 : 5'b10000;
  /*# cupu_fpu.vhd:584:13 */
  assign n2616 = n2610 ? cnt : n2612;
  /*# cupu_fpu.vhd:581:11 */
  assign n2618 = state == 5'b10010;
  /*# cupu_fpu.vhd:596:20 */
  assign n2619 = {28'b0, opn};  // uext
  /*# cupu_fpu.vhd:596:20 */
  assign n2621 = n2619 == 32'b00000000000000000000000000001001;
  /*# cupu_fpu.vhd:597:22 */
  assign n2622 = quad[0]; // extract
  /*# cupu_fpu.vhd:597:26 */
  assign n2623 = ~n2622;
  /*# cupu_fpu.vhd:598:27 */
  assign n2624 = y[65]; // extract
  /*# cupu_fpu.vhd:599:27 */
  assign n2625 = x[65]; // extract
  /*# cupu_fpu.vhd:601:27 */
  assign n2626 = x[65]; // extract
  /*# cupu_fpu.vhd:602:27 */
  assign n2627 = y[65]; // extract
  /*# cupu_fpu.vhd:597:15 */
  assign n2628 = n2623 ? n2624 : n2626;
  /*# cupu_fpu.vhd:597:15 */
  assign n2629 = n2623 ? n2625 : n2627;
  /*# cupu_fpu.vhd:604:29 */
  assign n2630 = n2628 ^ n2629;
  /*# cupu_fpu.vhd:604:47 */
  assign n2631 = quad[0]; // extract
  /*# cupu_fpu.vhd:604:39 */
  assign n2632 = n2630 ^ n2631;
  /*# cupu_fpu.vhd:604:51 */
  assign n2633 = n2632 ^ sa;
  /*# cupu_fpu.vhd:606:23 */
  assign n2634 = {28'b0, opn};  // uext
  /*# cupu_fpu.vhd:606:23 */
  assign n2636 = n2634 == 32'b00000000000000000000000000000111;
  /*# cupu_fpu.vhd:607:22 */
  assign n2637 = quad[0]; // extract
  /*# cupu_fpu.vhd:607:26 */
  assign n2638 = ~n2637;
  /*# cupu_fpu.vhd:607:15 */
  assign n2639 = n2638 ? y : x;
  /*# cupu_fpu.vhd:608:22 */
  assign n2640 = n2639[65]; // extract
  /*# cupu_fpu.vhd:608:35 */
  assign n2641 = quad[1]; // extract
  /*# cupu_fpu.vhd:608:27 */
  assign n2642 = n2640 ^ n2641;
  /*# cupu_fpu.vhd:608:39 */
  assign n2643 = n2642 ^ sa;
  /*# cupu_fpu.vhd:610:22 */
  assign n2644 = quad[0]; // extract
  /*# cupu_fpu.vhd:610:26 */
  assign n2645 = ~n2644;
  /*# cupu_fpu.vhd:610:15 */
  assign n2646 = n2645 ? x : y;
  /*# cupu_fpu.vhd:611:22 */
  assign n2647 = n2646[65]; // extract
  /*# cupu_fpu.vhd:611:36 */
  assign n2648 = quad[1]; // extract
  /*# cupu_fpu.vhd:611:48 */
  assign n2649 = quad[0]; // extract
  /*# cupu_fpu.vhd:611:40 */
  assign n2650 = n2648 ^ n2649;
  /*# cupu_fpu.vhd:611:27 */
  assign n2651 = n2647 ^ n2650;
  /*# cupu_fpu.vhd:606:13 */
  assign n2652 = n2636 ? n2643 : n2651;
  /*# cupu_fpu.vhd:596:13 */
  assign n2655 = n2621 ? 2'b01 : cont;
  /*# cupu_fpu.vhd:596:13 */
  assign n2656 = n2621 ? n2633 : n2652;
  /*# cupu_fpu.vhd:613:27 */
  assign n2660 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:591:11 */
  assign n2662 = state == 5'b10011;
  /*# cupu_fpu.vhd:622:27 */
  assign n2663 = add_s[65:0]; // extract
  /*# cupu_fpu.vhd:618:11 */
  assign n2665 = state == 5'b10100;
  /*# cupu_fpu.vhd:628:30 */
  assign n2666 = r[65:32]; // extract
  /*# cupu_fpu.vhd:628:22 */
  assign n2667 = {32'b0, n2666};  // uext
  /*# cupu_fpu.vhd:629:30 */
  assign n2668 = z[65:32]; // extract
  /*# cupu_fpu.vhd:629:22 */
  assign n2669 = {32'b0, n2668};  // uext
  /*# cupu_fpu.vhd:630:25 */
  assign n2670 = {{21{er[10]}}, er}; // sext
  /*# cupu_fpu.vhd:630:25 */
  assign n2671 = {{21{ed[10]}}, ed}; // sext
  /*# cupu_fpu.vhd:630:25 */
  assign n2672 = n2670 - n2671;
  /*# cupu_fpu.vhd:630:30 */
  assign n2674 = n2672 + 32'b00000000000000000000000000100110;
  /*# cupu_fpu.vhd:630:22 */
  assign n2675 = n2674[10:0];  // trunc
  /*# cupu_fpu.vhd:627:11 */
  assign n2677 = state == 5'b10101;
  /*# cupu_fpu.vhd:640:21 */
  assign n2679 = cont != 2'b00;
  /*# cupu_fpu.vhd:641:19 */
  assign n2680 = r[65]; // extract
  /*# cupu_fpu.vhd:641:24 */
  assign n2681 = ~n2680;
  /*# cupu_fpu.vhd:641:36 */
  assign n2683 = r != 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:641:30 */
  assign n2684 = n2683 & n2681;
  /*# cupu_fpu.vhd:642:24 */
  assign n2685 = r[64:0]; // extract
  /*# cupu_fpu.vhd:642:38 */
  assign n2687 = {n2685, 1'b0};
  /*# cupu_fpu.vhd:643:26 */
  assign n2688 = {{21{er[10]}}, er}; // sext
  /*# cupu_fpu.vhd:643:26 */
  assign n2690 = n2688 - 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:643:23 */
  assign n2691 = n2690[10:0];  // trunc
  /*# cupu_fpu.vhd:644:26 */
  assign n2693 = cont == 2'b01;
  /*# cupu_fpu.vhd:644:15 */
  assign n2696 = n2693 ? 5'b10100 : 5'b10101;
  /*# cupu_fpu.vhd:641:15 */
  assign n2697 = n2684 ? state : n2696;
  /*# cupu_fpu.vhd:641:15 */
  assign n2698 = n2684 ? n2687 : r;
  /*# cupu_fpu.vhd:641:15 */
  assign n2699 = n2684 ? n2691 : er;
  /*# cupu_fpu.vhd:649:21 */
  assign n2701 = r == 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:651:22 */
  assign n2702 = {{21{er[10]}}, er}; // sext
  /*# cupu_fpu.vhd:651:22 */
  assign n2704 = $signed(n2702) < $signed(32'b11111111111111111111111110000010);
  /*# cupu_fpu.vhd:652:29 */
  assign n2705 = r[65:1]; // extract
  /*# cupu_fpu.vhd:652:26 */
  assign n2707 = {1'b0, n2705};
  /*# cupu_fpu.vhd:653:30 */
  assign n2708 = r[0]; // extract
  /*# cupu_fpu.vhd:653:26 */
  assign n2709 = stk | n2708;
  /*# cupu_fpu.vhd:654:25 */
  assign n2710 = {{21{er[10]}}, er}; // sext
  /*# cupu_fpu.vhd:654:25 */
  assign n2712 = n2710 + 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:654:22 */
  assign n2713 = n2712[10:0];  // trunc
  /*# cupu_fpu.vhd:655:20 */
  assign n2714 = r[65]; // extract
  /*# cupu_fpu.vhd:655:25 */
  assign n2715 = ~n2714;
  /*# cupu_fpu.vhd:655:38 */
  assign n2716 = {{21{er[10]}}, er}; // sext
  /*# cupu_fpu.vhd:655:38 */
  assign n2718 = $signed(n2716) > $signed(32'b11111111111111111111111110000010);
  /*# cupu_fpu.vhd:655:31 */
  assign n2719 = n2718 & n2715;
  /*# cupu_fpu.vhd:656:22 */
  assign n2720 = r[64:0]; // extract
  /*# cupu_fpu.vhd:656:36 */
  assign n2722 = {n2720, 1'b0};
  /*# cupu_fpu.vhd:657:24 */
  assign n2723 = {{21{er[10]}}, er}; // sext
  /*# cupu_fpu.vhd:657:24 */
  assign n2725 = n2723 - 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:657:21 */
  assign n2726 = n2725[10:0];  // trunc
  /*# cupu_fpu.vhd:655:13 */
  assign n2728 = n2719 ? state : 5'b10111;
  /*# cupu_fpu.vhd:655:13 */
  assign n2729 = n2719 ? n2722 : r;
  /*# cupu_fpu.vhd:655:13 */
  assign n2730 = n2719 ? n2726 : er;
  /*# cupu_fpu.vhd:651:13 */
  assign n2731 = n2704 ? state : n2728;
  /*# cupu_fpu.vhd:651:13 */
  assign n2732 = n2704 ? n2707 : n2729;
  /*# cupu_fpu.vhd:651:13 */
  assign n2733 = n2704 ? n2713 : n2730;
  /*# cupu_fpu.vhd:651:13 */
  assign n2734 = n2704 ? n2709 : stk;
  /*# cupu_fpu.vhd:649:13 */
  assign n2736 = n2701 ? 5'b10111 : n2731;
  /*# cupu_fpu.vhd:649:13 */
  assign n2737 = n2701 ? r : n2732;
  /*# cupu_fpu.vhd:649:13 */
  assign n2738 = n2701 ? er : n2733;
  /*# cupu_fpu.vhd:649:13 */
  assign n2739 = n2701 ? stk : n2734;
  /*# cupu_fpu.vhd:640:13 */
  assign n2740 = n2679 ? n2697 : n2736;
  /*# cupu_fpu.vhd:640:13 */
  assign n2741 = n2679 ? n2698 : n2737;
  /*# cupu_fpu.vhd:640:13 */
  assign n2742 = n2679 ? n2699 : n2738;
  /*# cupu_fpu.vhd:640:13 */
  assign n2743 = n2679 ? stk : n2739;
  /*# cupu_fpu.vhd:639:11 */
  assign n2745 = state == 5'b10110;
  /*# cupu_fpu.vhd:664:17 */
  assign n2746 = r[40:0]; // extract
  /*# cupu_fpu.vhd:664:31 */
  assign n2748 = n2746 != 41'b00000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:664:13 */
  assign n2750 = n2748 ? 1'b1 : stk;
  /*# cupu_fpu.vhd:667:22 */
  assign n2751 = r[41]; // extract
  /*# cupu_fpu.vhd:667:43 */
  assign n2752 = r[42]; // extract
  /*# cupu_fpu.vhd:667:39 */
  assign n2753 = n2750 | n2752;
  /*# cupu_fpu.vhd:667:27 */
  assign n2754 = n2751 & n2753;
  /*# cupu_fpu.vhd:668:28 */
  assign n2755 = r[65:42]; // extract
  /*# cupu_fpu.vhd:668:25 */
  assign n2757 = {1'b0, n2755};
  /*# cupu_fpu.vhd:670:28 */
  assign n2759 = n2757 + 25'b0000000000000000000000001;
  /*# cupu_fpu.vhd:669:13 */
  assign n2760 = n2754 ? n2759 : n2757;
  /*# cupu_fpu.vhd:673:20 */
  assign n2761 = n2760[24]; // extract
  /*# cupu_fpu.vhd:674:33 */
  assign n2762 = n2760[24:1]; // extract
  /*# cupu_fpu.vhd:674:27 */
  assign n2764 = {1'b0, n2762};
  /*# cupu_fpu.vhd:675:26 */
  assign n2765 = {{21{er[10]}}, er}; // sext
  /*# cupu_fpu.vhd:675:26 */
  assign n2767 = n2765 + 32'b00000000000000000000000000000001;
  /*# cupu_fpu.vhd:675:15 */
  assign n2768 = n2767[10:0];  // trunc
  /*# cupu_fpu.vhd:673:13 */
  assign n2769 = n2761 ? n2764 : n2760;
  /*# cupu_fpu.vhd:673:13 */
  assign n2770 = n2761 ? n2768 : er;
  /*# cupu_fpu.vhd:677:18 */
  assign n2772 = r == 66'b000000000000000000000000000000000000000000000000000000000000000000;
  /*# cupu_fpu.vhd:677:30 */
  assign n2773 = ~stk;
  /*# cupu_fpu.vhd:677:22 */
  assign n2774 = n2773 & n2772;
  /*# cupu_fpu.vhd:678:27 */
  assign n2776 = {sr, 31'b0000000000000000000000000000000};
  /*# cupu_fpu.vhd:679:23 */
  assign n2777 = n2769[23]; // extract
  /*# cupu_fpu.vhd:679:28 */
  assign n2778 = ~n2777;
  /*# cupu_fpu.vhd:680:27 */
  assign n2780 = {sr, 8'b00000000};
  /*# cupu_fpu.vhd:680:63 */
  assign n2781 = n2769[22:0]; // extract
  /*# cupu_fpu.vhd:680:40 */
  assign n2782 = {n2780, n2781};
  /*# cupu_fpu.vhd:681:22 */
  assign n2783 = {{21{n2770[10]}}, n2770}; // sext
  /*# cupu_fpu.vhd:681:22 */
  assign n2785 = $signed(n2783) > $signed(32'b00000000000000000000000001111111);
  /*# cupu_fpu.vhd:682:27 */
  assign n2787 = {sr, 31'b1111111100000000000000000000000};
  /*# cupu_fpu.vhd:684:61 */
  assign n2788 = {{21{n2770[10]}}, n2770}; // sext
  /*# cupu_fpu.vhd:684:61 */
  assign n2790 = n2788 + 32'b00000000000000000000000001111111;
  /*# cupu_fpu.vhd:684:58 */
  assign n2791 = n2790[30:0];  // trunc
  /*# cupu_fpu.vhd:684:46 */
  assign n2792 = n2791[7:0];  // trunc
  /*# cupu_fpu.vhd:684:27 */
  assign n2793 = {sr, n2792};
  /*# cupu_fpu.vhd:684:95 */
  assign n2794 = n2769[22:0]; // extract
  /*# cupu_fpu.vhd:684:72 */
  assign n2795 = {n2793, n2794};
  /*# cupu_fpu.vhd:681:13 */
  assign n2796 = n2785 ? n2787 : n2795;
  /*# cupu_fpu.vhd:679:13 */
  assign n2797 = n2778 ? n2782 : n2796;
  /*# cupu_fpu.vhd:677:13 */
  assign n2798 = n2774 ? n2776 : n2797;
  /*# cupu_fpu.vhd:662:11 */
  assign n2800 = state == 5'b10111;
  /*# cupu_fpu.vhd:688:11 */
  assign n2802 = state == 5'b11000;
  /*# cupu_fpu.vhd:258:9 */
  assign n2803 = {n2802, n2800, n2745, n2677, n2665, n2662, n2618, n2606, n2603, n2600, n2580, n2570, n2560, n2547, n2517, n2504, n2475, n2450, n2424, n2421, n2418, n2403, n2395, n2378, n2276};
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2816 = 5'b00000;
      25'b0100000000000000000000000: n2816 = 5'b11000;
      25'b0010000000000000000000000: n2816 = n2740;
      25'b0001000000000000000000000: n2816 = 5'b01000;
      25'b0000100000000000000000000: n2816 = 5'b10110;
      25'b0000010000000000000000000: n2816 = 5'b10110;
      25'b0000001000000000000000000: n2816 = n2615;
      25'b0000000100000000000000000: n2816 = 5'b10010;
      25'b0000000010000000000000000: n2816 = 5'b10001;
      25'b0000000001000000000000000: n2816 = n2591;
      25'b0000000000100000000000000: n2816 = n2577;
      25'b0000000000010000000000000: n2816 = 5'b01110;
      25'b0000000000001000000000000: n2816 = n2556;
      25'b0000000000000100000000000: n2816 = n2544;
      25'b0000000000000010000000000: n2816 = n2513;
      25'b0000000000000001000000000: n2816 = n2496;
      25'b0000000000000000100000000: n2816 = n2469;
      25'b0000000000000000010000000: n2816 = n2442;
      25'b0000000000000000001000000: n2816 = 5'b11000;
      25'b0000000000000000000100000: n2816 = 5'b00110;
      25'b0000000000000000000010000: n2816 = n2413;
      25'b0000000000000000000001000: n2816 = 5'b10110;
      25'b0000000000000000000000100: n2816 = n2391;
      25'b0000000000000000000000010: n2816 = n2366;
      25'b0000000000000000000000001: n2816 = n2261;
      default: n2816 = 5'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2821 = cont;
      25'b0100000000000000000000000: n2821 = cont;
      25'b0010000000000000000000000: n2821 = cont;
      25'b0001000000000000000000000: n2821 = 2'b00;
      25'b0000100000000000000000000: n2821 = 2'b10;
      25'b0000010000000000000000000: n2821 = n2655;
      25'b0000001000000000000000000: n2821 = cont;
      25'b0000000100000000000000000: n2821 = cont;
      25'b0000000010000000000000000: n2821 = cont;
      25'b0000000001000000000000000: n2821 = cont;
      25'b0000000000100000000000000: n2821 = cont;
      25'b0000000000010000000000000: n2821 = cont;
      25'b0000000000001000000000000: n2821 = cont;
      25'b0000000000000100000000000: n2821 = cont;
      25'b0000000000000010000000000: n2821 = cont;
      25'b0000000000000001000000000: n2821 = cont;
      25'b0000000000000000100000000: n2821 = cont;
      25'b0000000000000000010000000: n2821 = cont;
      25'b0000000000000000001000000: n2821 = cont;
      25'b0000000000000000000100000: n2821 = cont;
      25'b0000000000000000000010000: n2821 = cont;
      25'b0000000000000000000001000: n2821 = cont;
      25'b0000000000000000000000100: n2821 = cont;
      25'b0000000000000000000000010: n2821 = cont;
      25'b0000000000000000000000001: n2821 = 2'b00;
      default: n2821 = 2'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2824 = r;
      25'b0100000000000000000000000: n2824 = r;
      25'b0010000000000000000000000: n2824 = n2741;
      25'b0001000000000000000000000: n2824 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
      25'b0000100000000000000000000: n2824 = n2663;
      25'b0000010000000000000000000: n2824 = n2660;
      25'b0000001000000000000000000: n2824 = r;
      25'b0000000100000000000000000: n2824 = r;
      25'b0000000010000000000000000: n2824 = r;
      25'b0000000001000000000000000: n2824 = r;
      25'b0000000000100000000000000: n2824 = r;
      25'b0000000000010000000000000: n2824 = r;
      25'b0000000000001000000000000: n2824 = r;
      25'b0000000000000100000000000: n2824 = r;
      25'b0000000000000010000000000: n2824 = r;
      25'b0000000000000001000000000: n2824 = n2497;
      25'b0000000000000000100000000: n2824 = n2470;
      25'b0000000000000000010000000: n2824 = n2443;
      25'b0000000000000000001000000: n2824 = r;
      25'b0000000000000000000100000: n2824 = r;
      25'b0000000000000000000010000: n2824 = r;
      25'b0000000000000000000001000: n2824 = n2396;
      25'b0000000000000000000000100: n2824 = r;
      25'b0000000000000000000000010: n2824 = n2367;
      25'b0000000000000000000000001: n2824 = n2262;
      default: n2824 = 66'bX;
    endcase
  /*# cupu_fpu.vhd:267:13 */
  assign n2825 = n2263[47:0]; // extract
  /*# cupu_fpu.vhd:386:13 */
  assign n2826 = n2368[47:0]; // extract
  /*# cupu_fpu.vhd:424:13 */
  assign n2827 = n2392[47:0]; // extract
  /*# cupu_fpu.vhd:440:13 */
  assign n2828 = n2414[47:0]; // extract
  /*# cupu_fpu.vhd:449:27 */
  assign n2829 = n2419[47:0]; // extract
  /*# cupu_fpu.vhd:471:13 */
  assign n2830 = n2471[47:0]; // extract
  /*# cupu_fpu.vhd:488:13 */
  assign n2831 = n2498[47:0]; // extract
  /*# cupu_fpu.vhd:546:31 */
  assign n2832 = n2568[47:0]; // extract
  /*# cupu_fpu.vhd:562:13 */
  assign n2833 = n2594[47:0]; // extract
  /*# cupu_fpu.vhd:582:19 */
  assign n2834 = n2607[47:0]; // extract
  /*# cupu_fpu.vhd:628:22 */
  assign n2835 = n2667[47:0]; // extract
  /*# cupu_fpu.vhd:75:13 */
  assign n2836 = x[47:0]; // extract
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2838 = n2836;
      25'b0100000000000000000000000: n2838 = n2836;
      25'b0010000000000000000000000: n2838 = n2836;
      25'b0001000000000000000000000: n2838 = n2835;
      25'b0000100000000000000000000: n2838 = n2836;
      25'b0000010000000000000000000: n2838 = n2836;
      25'b0000001000000000000000000: n2838 = n2834;
      25'b0000000100000000000000000: n2838 = n2836;
      25'b0000000010000000000000000: n2838 = n2836;
      25'b0000000001000000000000000: n2838 = n2833;
      25'b0000000000100000000000000: n2838 = n2836;
      25'b0000000000010000000000000: n2838 = n2832;
      25'b0000000000001000000000000: n2838 = n2836;
      25'b0000000000000100000000000: n2838 = n2836;
      25'b0000000000000010000000000: n2838 = n2836;
      25'b0000000000000001000000000: n2838 = n2831;
      25'b0000000000000000100000000: n2838 = n2830;
      25'b0000000000000000010000000: n2838 = n2445;
      25'b0000000000000000001000000: n2838 = n2836;
      25'b0000000000000000000100000: n2838 = n2829;
      25'b0000000000000000000010000: n2838 = n2828;
      25'b0000000000000000000001000: n2838 = n2836;
      25'b0000000000000000000000100: n2838 = n2827;
      25'b0000000000000000000000010: n2838 = n2826;
      25'b0000000000000000000000001: n2838 = n2825;
      default: n2838 = 48'bX;
    endcase
  /*# cupu_fpu.vhd:267:13 */
  assign n2839 = n2263[65:48]; // extract
  /*# cupu_fpu.vhd:386:13 */
  assign n2840 = n2368[65:48]; // extract
  /*# cupu_fpu.vhd:424:13 */
  assign n2841 = n2392[65:48]; // extract
  /*# cupu_fpu.vhd:440:13 */
  assign n2842 = n2414[65:48]; // extract
  /*# cupu_fpu.vhd:449:27 */
  assign n2843 = n2419[65:48]; // extract
  /*# cupu_fpu.vhd:471:13 */
  assign n2844 = n2471[65:48]; // extract
  /*# cupu_fpu.vhd:488:13 */
  assign n2845 = n2498[65:48]; // extract
  /*# cupu_fpu.vhd:546:31 */
  assign n2846 = n2568[65:48]; // extract
  /*# cupu_fpu.vhd:562:13 */
  assign n2847 = n2594[65:48]; // extract
  /*# cupu_fpu.vhd:582:19 */
  assign n2848 = n2607[65:48]; // extract
  /*# cupu_fpu.vhd:628:22 */
  assign n2849 = n2667[65:48]; // extract
  /*# cupu_fpu.vhd:75:13 */
  assign n2850 = x[65:48]; // extract
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2852 = n2850;
      25'b0100000000000000000000000: n2852 = n2850;
      25'b0010000000000000000000000: n2852 = n2850;
      25'b0001000000000000000000000: n2852 = n2849;
      25'b0000100000000000000000000: n2852 = n2850;
      25'b0000010000000000000000000: n2852 = n2850;
      25'b0000001000000000000000000: n2852 = n2848;
      25'b0000000100000000000000000: n2852 = n2850;
      25'b0000000010000000000000000: n2852 = n2850;
      25'b0000000001000000000000000: n2852 = n2847;
      25'b0000000000100000000000000: n2852 = n2850;
      25'b0000000000010000000000000: n2852 = n2846;
      25'b0000000000001000000000000: n2852 = n2850;
      25'b0000000000000100000000000: n2852 = n2850;
      25'b0000000000000010000000000: n2852 = n2850;
      25'b0000000000000001000000000: n2852 = n2845;
      25'b0000000000000000100000000: n2852 = n2844;
      25'b0000000000000000010000000: n2852 = n2850;
      25'b0000000000000000001000000: n2852 = n2850;
      25'b0000000000000000000100000: n2852 = n2843;
      25'b0000000000000000000010000: n2852 = n2842;
      25'b0000000000000000000001000: n2852 = n2850;
      25'b0000000000000000000000100: n2852 = n2841;
      25'b0000000000000000000000010: n2852 = n2840;
      25'b0000000000000000000000001: n2852 = n2839;
      default: n2852 = 18'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2854 = y;
      25'b0100000000000000000000000: n2854 = y;
      25'b0010000000000000000000000: n2854 = y;
      25'b0001000000000000000000000: n2854 = n2669;
      25'b0000100000000000000000000: n2854 = y;
      25'b0000010000000000000000000: n2854 = y;
      25'b0000001000000000000000000: n2854 = y;
      25'b0000000100000000000000000: n2854 = n2604;
      25'b0000000010000000000000000: n2854 = y;
      25'b0000000001000000000000000: n2854 = n2596;
      25'b0000000000100000000000000: n2854 = y;
      25'b0000000000010000000000000: n2854 = y;
      25'b0000000000001000000000000: n2854 = y;
      25'b0000000000000100000000000: n2854 = y;
      25'b0000000000000010000000000: n2854 = y;
      25'b0000000000000001000000000: n2854 = n2499;
      25'b0000000000000000100000000: n2854 = y;
      25'b0000000000000000010000000: n2854 = n2446;
      25'b0000000000000000001000000: n2854 = y;
      25'b0000000000000000000100000: n2854 = y;
      25'b0000000000000000000010000: n2854 = y;
      25'b0000000000000000000001000: n2854 = y;
      25'b0000000000000000000000100: n2854 = y;
      25'b0000000000000000000000010: n2854 = n2369;
      25'b0000000000000000000000001: n2854 = y;
      default: n2854 = 66'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2857 = z;
      25'b0100000000000000000000000: n2857 = z;
      25'b0010000000000000000000000: n2857 = z;
      25'b0001000000000000000000000: n2857 = z;
      25'b0000100000000000000000000: n2857 = r;
      25'b0000010000000000000000000: n2857 = z;
      25'b0000001000000000000000000: n2857 = n2608;
      25'b0000000100000000000000000: n2857 = z;
      25'b0000000010000000000000000: n2857 = z;
      25'b0000000001000000000000000: n2857 = z;
      25'b0000000000100000000000000: n2857 = n2571;
      25'b0000000000010000000000000: n2857 = 66'b000000000000000000000000000000000000000000000000000000000000000000;
      25'b0000000000001000000000000: n2857 = z;
      25'b0000000000000100000000000: n2857 = z;
      25'b0000000000000010000000000: n2857 = n2514;
      25'b0000000000000001000000000: n2857 = n2500;
      25'b0000000000000000100000000: n2857 = z;
      25'b0000000000000000010000000: n2857 = z;
      25'b0000000000000000001000000: n2857 = z;
      25'b0000000000000000000100000: n2857 = z;
      25'b0000000000000000000010000: n2857 = z;
      25'b0000000000000000000001000: n2857 = z;
      25'b0000000000000000000000100: n2857 = z;
      25'b0000000000000000000000010: n2857 = n2370;
      25'b0000000000000000000000001: n2857 = n2264;
      default: n2857 = 66'bX;
    endcase
  /*# cupu_fpu.vhd:267:13 */
  assign n2858 = n2265[65:0]; // extract
  /*# cupu_fpu.vhd:519:37 */
  assign n2859 = n2520[65:0]; // extract
  /*# cupu_fpu.vhd:536:13 */
  assign n2860 = n2557[65:0]; // extract
  /*# cupu_fpu.vhd:76:10 */
  assign n2861 = w[65:0]; // extract
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2863 = n2861;
      25'b0100000000000000000000000: n2863 = n2861;
      25'b0010000000000000000000000: n2863 = n2861;
      25'b0001000000000000000000000: n2863 = n2861;
      25'b0000100000000000000000000: n2863 = n2861;
      25'b0000010000000000000000000: n2863 = n2861;
      25'b0000001000000000000000000: n2863 = n2861;
      25'b0000000100000000000000000: n2863 = n2861;
      25'b0000000010000000000000000: n2863 = n2601;
      25'b0000000001000000000000000: n2863 = n2861;
      25'b0000000000100000000000000: n2863 = n2861;
      25'b0000000000010000000000000: n2863 = n2861;
      25'b0000000000001000000000000: n2863 = n2860;
      25'b0000000000000100000000000: n2863 = n2859;
      25'b0000000000000010000000000: n2863 = n2861;
      25'b0000000000000001000000000: n2863 = n2861;
      25'b0000000000000000100000000: n2863 = n2861;
      25'b0000000000000000010000000: n2863 = n2861;
      25'b0000000000000000001000000: n2863 = n2861;
      25'b0000000000000000000100000: n2863 = n2861;
      25'b0000000000000000000010000: n2863 = n2861;
      25'b0000000000000000000001000: n2863 = n2861;
      25'b0000000000000000000000100: n2863 = n2861;
      25'b0000000000000000000000010: n2863 = n2861;
      25'b0000000000000000000000001: n2863 = n2858;
      default: n2863 = 66'bX;
    endcase
  /*# cupu_fpu.vhd:267:13 */
  assign n2864 = n2265[91:66]; // extract
  /*# cupu_fpu.vhd:519:37 */
  assign n2865 = n2520[91:66]; // extract
  /*# cupu_fpu.vhd:536:13 */
  assign n2866 = n2557[91:66]; // extract
  /*# cupu_fpu.vhd:76:10 */
  assign n2867 = w[91:66]; // extract
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2869 = n2867;
      25'b0100000000000000000000000: n2869 = n2867;
      25'b0010000000000000000000000: n2869 = n2867;
      25'b0001000000000000000000000: n2869 = n2867;
      25'b0000100000000000000000000: n2869 = n2867;
      25'b0000010000000000000000000: n2869 = n2867;
      25'b0000001000000000000000000: n2869 = n2867;
      25'b0000000100000000000000000: n2869 = n2867;
      25'b0000000010000000000000000: n2869 = n2867;
      25'b0000000001000000000000000: n2869 = n2867;
      25'b0000000000100000000000000: n2869 = n2867;
      25'b0000000000010000000000000: n2869 = n2867;
      25'b0000000000001000000000000: n2869 = n2866;
      25'b0000000000000100000000000: n2869 = n2865;
      25'b0000000000000010000000000: n2869 = n2867;
      25'b0000000000000001000000000: n2869 = n2867;
      25'b0000000000000000100000000: n2869 = n2867;
      25'b0000000000000000010000000: n2869 = n2867;
      25'b0000000000000000001000000: n2869 = n2867;
      25'b0000000000000000000100000: n2869 = n2867;
      25'b0000000000000000000010000: n2869 = n2867;
      25'b0000000000000000000001000: n2869 = n2867;
      25'b0000000000000000000000100: n2869 = n2867;
      25'b0000000000000000000000010: n2869 = n2867;
      25'b0000000000000000000000001: n2869 = n2864;
      default: n2869 = 26'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2871 = ma;
      25'b0100000000000000000000000: n2871 = ma;
      25'b0010000000000000000000000: n2871 = ma;
      25'b0001000000000000000000000: n2871 = ma;
      25'b0000100000000000000000000: n2871 = ma;
      25'b0000010000000000000000000: n2871 = ma;
      25'b0000001000000000000000000: n2871 = ma;
      25'b0000000100000000000000000: n2871 = ma;
      25'b0000000010000000000000000: n2871 = ma;
      25'b0000000001000000000000000: n2871 = ma;
      25'b0000000000100000000000000: n2871 = ma;
      25'b0000000000010000000000000: n2871 = ma;
      25'b0000000000001000000000000: n2871 = ma;
      25'b0000000000000100000000000: n2871 = ma;
      25'b0000000000000010000000000: n2871 = ma;
      25'b0000000000000001000000000: n2871 = ma;
      25'b0000000000000000100000000: n2871 = ma;
      25'b0000000000000000010000000: n2871 = ma;
      25'b0000000000000000001000000: n2871 = ma;
      25'b0000000000000000000100000: n2871 = ma;
      25'b0000000000000000000010000: n2871 = ma;
      25'b0000000000000000000001000: n2871 = ma;
      25'b0000000000000000000000100: n2871 = ma;
      25'b0000000000000000000000010: n2871 = n2371;
      25'b0000000000000000000000001: n2871 = a_m;
      default: n2871 = 24'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2873 = mb;
      25'b0100000000000000000000000: n2873 = mb;
      25'b0010000000000000000000000: n2873 = mb;
      25'b0001000000000000000000000: n2873 = mb;
      25'b0000100000000000000000000: n2873 = mb;
      25'b0000010000000000000000000: n2873 = mb;
      25'b0000001000000000000000000: n2873 = mb;
      25'b0000000100000000000000000: n2873 = mb;
      25'b0000000010000000000000000: n2873 = mb;
      25'b0000000001000000000000000: n2873 = mb;
      25'b0000000000100000000000000: n2873 = mb;
      25'b0000000000010000000000000: n2873 = mb;
      25'b0000000000001000000000000: n2873 = mb;
      25'b0000000000000100000000000: n2873 = mb;
      25'b0000000000000010000000000: n2873 = mb;
      25'b0000000000000001000000000: n2873 = mb;
      25'b0000000000000000100000000: n2873 = mb;
      25'b0000000000000000010000000: n2873 = mb;
      25'b0000000000000000001000000: n2873 = mb;
      25'b0000000000000000000100000: n2873 = mb;
      25'b0000000000000000000010000: n2873 = mb;
      25'b0000000000000000000001000: n2873 = mb;
      25'b0000000000000000000000100: n2873 = mb;
      25'b0000000000000000000000010: n2873 = n2372;
      25'b0000000000000000000000001: n2873 = n2266;
      default: n2873 = 24'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2875 = ea;
      25'b0100000000000000000000000: n2875 = ea;
      25'b0010000000000000000000000: n2875 = ea;
      25'b0001000000000000000000000: n2875 = ea;
      25'b0000100000000000000000000: n2875 = ea;
      25'b0000010000000000000000000: n2875 = ea;
      25'b0000001000000000000000000: n2875 = ea;
      25'b0000000100000000000000000: n2875 = ea;
      25'b0000000010000000000000000: n2875 = ea;
      25'b0000000001000000000000000: n2875 = ea;
      25'b0000000000100000000000000: n2875 = ea;
      25'b0000000000010000000000000: n2875 = ea;
      25'b0000000000001000000000000: n2875 = ea;
      25'b0000000000000100000000000: n2875 = ea;
      25'b0000000000000010000000000: n2875 = ea;
      25'b0000000000000001000000000: n2875 = ea;
      25'b0000000000000000100000000: n2875 = ea;
      25'b0000000000000000010000000: n2875 = ea;
      25'b0000000000000000001000000: n2875 = ea;
      25'b0000000000000000000100000: n2875 = ea;
      25'b0000000000000000000010000: n2875 = ea;
      25'b0000000000000000000001000: n2875 = ea;
      25'b0000000000000000000000100: n2875 = ea;
      25'b0000000000000000000000010: n2875 = n2373;
      25'b0000000000000000000000001: n2875 = a_e;
      default: n2875 = 11'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2877 = eb;
      25'b0100000000000000000000000: n2877 = eb;
      25'b0010000000000000000000000: n2877 = eb;
      25'b0001000000000000000000000: n2877 = eb;
      25'b0000100000000000000000000: n2877 = eb;
      25'b0000010000000000000000000: n2877 = eb;
      25'b0000001000000000000000000: n2877 = eb;
      25'b0000000100000000000000000: n2877 = eb;
      25'b0000000010000000000000000: n2877 = eb;
      25'b0000000001000000000000000: n2877 = eb;
      25'b0000000000100000000000000: n2877 = eb;
      25'b0000000000010000000000000: n2877 = eb;
      25'b0000000000001000000000000: n2877 = eb;
      25'b0000000000000100000000000: n2877 = eb;
      25'b0000000000000010000000000: n2877 = eb;
      25'b0000000000000001000000000: n2877 = eb;
      25'b0000000000000000100000000: n2877 = eb;
      25'b0000000000000000010000000: n2877 = eb;
      25'b0000000000000000001000000: n2877 = eb;
      25'b0000000000000000000100000: n2877 = eb;
      25'b0000000000000000000010000: n2877 = eb;
      25'b0000000000000000000001000: n2877 = eb;
      25'b0000000000000000000000100: n2877 = eb;
      25'b0000000000000000000000010: n2877 = n2374;
      25'b0000000000000000000000001: n2877 = b_e;
      default: n2877 = 11'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2881 = er;
      25'b0100000000000000000000000: n2881 = er;
      25'b0010000000000000000000000: n2881 = n2742;
      25'b0001000000000000000000000: n2881 = n2675;
      25'b0000100000000000000000000: n2881 = 11'b00000000011;
      25'b0000010000000000000000000: n2881 = 11'b00000000011;
      25'b0000001000000000000000000: n2881 = er;
      25'b0000000100000000000000000: n2881 = er;
      25'b0000000010000000000000000: n2881 = er;
      25'b0000000001000000000000000: n2881 = er;
      25'b0000000000100000000000000: n2881 = er;
      25'b0000000000010000000000000: n2881 = er;
      25'b0000000000001000000000000: n2881 = er;
      25'b0000000000000100000000000: n2881 = er;
      25'b0000000000000010000000000: n2881 = er;
      25'b0000000000000001000000000: n2881 = er;
      25'b0000000000000000100000000: n2881 = er;
      25'b0000000000000000010000000: n2881 = n2447;
      25'b0000000000000000001000000: n2881 = er;
      25'b0000000000000000000100000: n2881 = er;
      25'b0000000000000000000010000: n2881 = er;
      25'b0000000000000000000001000: n2881 = er;
      25'b0000000000000000000000100: n2881 = er;
      25'b0000000000000000000000010: n2881 = n2375;
      25'b0000000000000000000000001: n2881 = n2267;
      default: n2881 = 11'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2883 = ed;
      25'b0100000000000000000000000: n2883 = ed;
      25'b0010000000000000000000000: n2883 = ed;
      25'b0001000000000000000000000: n2883 = ed;
      25'b0000100000000000000000000: n2883 = er;
      25'b0000010000000000000000000: n2883 = ed;
      25'b0000001000000000000000000: n2883 = ed;
      25'b0000000100000000000000000: n2883 = ed;
      25'b0000000010000000000000000: n2883 = ed;
      25'b0000000001000000000000000: n2883 = ed;
      25'b0000000000100000000000000: n2883 = ed;
      25'b0000000000010000000000000: n2883 = ed;
      25'b0000000000001000000000000: n2883 = ed;
      25'b0000000000000100000000000: n2883 = ed;
      25'b0000000000000010000000000: n2883 = ed;
      25'b0000000000000001000000000: n2883 = ed;
      25'b0000000000000000100000000: n2883 = ed;
      25'b0000000000000000010000000: n2883 = ed;
      25'b0000000000000000001000000: n2883 = ed;
      25'b0000000000000000000100000: n2883 = ed;
      25'b0000000000000000000010000: n2883 = ed;
      25'b0000000000000000000001000: n2883 = ed;
      25'b0000000000000000000000100: n2883 = ed;
      25'b0000000000000000000000010: n2883 = ed;
      25'b0000000000000000000000001: n2883 = ed;
      default: n2883 = 11'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2885 = sr;
      25'b0100000000000000000000000: n2885 = sr;
      25'b0010000000000000000000000: n2885 = sr;
      25'b0001000000000000000000000: n2885 = sr;
      25'b0000100000000000000000000: n2885 = sr;
      25'b0000010000000000000000000: n2885 = n2656;
      25'b0000001000000000000000000: n2885 = sr;
      25'b0000000100000000000000000: n2885 = sr;
      25'b0000000010000000000000000: n2885 = sr;
      25'b0000000001000000000000000: n2885 = sr;
      25'b0000000000100000000000000: n2885 = sr;
      25'b0000000000010000000000000: n2885 = sr;
      25'b0000000000001000000000000: n2885 = sr;
      25'b0000000000000100000000000: n2885 = sr;
      25'b0000000000000010000000000: n2885 = sr;
      25'b0000000000000001000000000: n2885 = sr;
      25'b0000000000000000100000000: n2885 = sr;
      25'b0000000000000000010000000: n2885 = sr;
      25'b0000000000000000001000000: n2885 = sr;
      25'b0000000000000000000100000: n2885 = sr;
      25'b0000000000000000000010000: n2885 = sr;
      25'b0000000000000000000001000: n2885 = n2401;
      25'b0000000000000000000000100: n2885 = sr;
      25'b0000000000000000000000010: n2885 = sr;
      25'b0000000000000000000000001: n2885 = n2268;
      default: n2885 = 1'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2889 = stk;
      25'b0100000000000000000000000: n2889 = stk;
      25'b0010000000000000000000000: n2889 = n2743;
      25'b0001000000000000000000000: n2889 = stk;
      25'b0000100000000000000000000: n2889 = stk;
      25'b0000010000000000000000000: n2889 = 1'b0;
      25'b0000001000000000000000000: n2889 = stk;
      25'b0000000100000000000000000: n2889 = stk;
      25'b0000000010000000000000000: n2889 = stk;
      25'b0000000001000000000000000: n2889 = stk;
      25'b0000000000100000000000000: n2889 = stk;
      25'b0000000000010000000000000: n2889 = stk;
      25'b0000000000001000000000000: n2889 = stk;
      25'b0000000000000100000000000: n2889 = stk;
      25'b0000000000000010000000000: n2889 = stk;
      25'b0000000000000001000000000: n2889 = n2481;
      25'b0000000000000000100000000: n2889 = n2456;
      25'b0000000000000000010000000: n2889 = stk;
      25'b0000000000000000001000000: n2889 = stk;
      25'b0000000000000000000100000: n2889 = stk;
      25'b0000000000000000000010000: n2889 = n2415;
      25'b0000000000000000000001000: n2889 = stk;
      25'b0000000000000000000000100: n2889 = stk;
      25'b0000000000000000000000010: n2889 = stk;
      25'b0000000000000000000000001: n2889 = 1'b0;
      default: n2889 = 1'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2891 = effsub;
      25'b0100000000000000000000000: n2891 = effsub;
      25'b0010000000000000000000000: n2891 = effsub;
      25'b0001000000000000000000000: n2891 = effsub;
      25'b0000100000000000000000000: n2891 = effsub;
      25'b0000010000000000000000000: n2891 = effsub;
      25'b0000001000000000000000000: n2891 = effsub;
      25'b0000000100000000000000000: n2891 = effsub;
      25'b0000000010000000000000000: n2891 = effsub;
      25'b0000000001000000000000000: n2891 = effsub;
      25'b0000000000100000000000000: n2891 = effsub;
      25'b0000000000010000000000000: n2891 = effsub;
      25'b0000000000001000000000000: n2891 = effsub;
      25'b0000000000000100000000000: n2891 = effsub;
      25'b0000000000000010000000000: n2891 = effsub;
      25'b0000000000000001000000000: n2891 = effsub;
      25'b0000000000000000100000000: n2891 = effsub;
      25'b0000000000000000010000000: n2891 = effsub;
      25'b0000000000000000001000000: n2891 = effsub;
      25'b0000000000000000000100000: n2891 = effsub;
      25'b0000000000000000000010000: n2891 = effsub;
      25'b0000000000000000000001000: n2891 = effsub;
      25'b0000000000000000000000100: n2891 = effsub;
      25'b0000000000000000000000010: n2891 = effsub;
      25'b0000000000000000000000001: n2891 = n2269;
      default: n2891 = 1'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2895 = cnt;
      25'b0100000000000000000000000: n2895 = cnt;
      25'b0010000000000000000000000: n2895 = cnt;
      25'b0001000000000000000000000: n2895 = 8'b00011100;
      25'b0000100000000000000000000: n2895 = cnt;
      25'b0000010000000000000000000: n2895 = cnt;
      25'b0000001000000000000000000: n2895 = n2616;
      25'b0000000100000000000000000: n2895 = cnt;
      25'b0000000010000000000000000: n2895 = cnt;
      25'b0000000001000000000000000: n2895 = n2598;
      25'b0000000000100000000000000: n2895 = n2578;
      25'b0000000000010000000000000: n2895 = 8'b01000000;
      25'b0000000000001000000000000: n2895 = n2558;
      25'b0000000000000100000000000: n2895 = n2545;
      25'b0000000000000010000000000: n2895 = n2515;
      25'b0000000000000001000000000: n2895 = n2502;
      25'b0000000000000000100000000: n2895 = n2473;
      25'b0000000000000000010000000: n2895 = n2448;
      25'b0000000000000000001000000: n2895 = cnt;
      25'b0000000000000000000100000: n2895 = cnt;
      25'b0000000000000000000010000: n2895 = n2416;
      25'b0000000000000000000001000: n2895 = cnt;
      25'b0000000000000000000000100: n2895 = n2393;
      25'b0000000000000000000000010: n2895 = n2376;
      25'b0000000000000000000000001: n2895 = n2270;
      default: n2895 = 8'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2897 = quad;
      25'b0100000000000000000000000: n2897 = quad;
      25'b0010000000000000000000000: n2897 = quad;
      25'b0001000000000000000000000: n2897 = quad;
      25'b0000100000000000000000000: n2897 = quad;
      25'b0000010000000000000000000: n2897 = quad;
      25'b0000001000000000000000000: n2897 = quad;
      25'b0000000100000000000000000: n2897 = quad;
      25'b0000000010000000000000000: n2897 = quad;
      25'b0000000001000000000000000: n2897 = quad;
      25'b0000000000100000000000000: n2897 = quad;
      25'b0000000000010000000000000: n2897 = n2565;
      25'b0000000000001000000000000: n2897 = quad;
      25'b0000000000000100000000000: n2897 = quad;
      25'b0000000000000010000000000: n2897 = quad;
      25'b0000000000000001000000000: n2897 = quad;
      25'b0000000000000000100000000: n2897 = quad;
      25'b0000000000000000010000000: n2897 = quad;
      25'b0000000000000000001000000: n2897 = quad;
      25'b0000000000000000000100000: n2897 = quad;
      25'b0000000000000000000010000: n2897 = quad;
      25'b0000000000000000000001000: n2897 = quad;
      25'b0000000000000000000000100: n2897 = quad;
      25'b0000000000000000000000010: n2897 = quad;
      25'b0000000000000000000000001: n2897 = n2271;
      default: n2897 = 2'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2899 = res_r;
      25'b0100000000000000000000000: n2899 = n2798;
      25'b0010000000000000000000000: n2899 = res_r;
      25'b0001000000000000000000000: n2899 = res_r;
      25'b0000100000000000000000000: n2899 = res_r;
      25'b0000010000000000000000000: n2899 = res_r;
      25'b0000001000000000000000000: n2899 = res_r;
      25'b0000000100000000000000000: n2899 = res_r;
      25'b0000000010000000000000000: n2899 = res_r;
      25'b0000000001000000000000000: n2899 = res_r;
      25'b0000000000100000000000000: n2899 = res_r;
      25'b0000000000010000000000000: n2899 = res_r;
      25'b0000000000001000000000000: n2899 = res_r;
      25'b0000000000000100000000000: n2899 = res_r;
      25'b0000000000000010000000000: n2899 = res_r;
      25'b0000000000000001000000000: n2899 = res_r;
      25'b0000000000000000100000000: n2899 = res_r;
      25'b0000000000000000010000000: n2899 = res_r;
      25'b0000000000000000001000000: n2899 = n2422;
      25'b0000000000000000000100000: n2899 = res_r;
      25'b0000000000000000000010000: n2899 = res_r;
      25'b0000000000000000000001000: n2899 = res_r;
      25'b0000000000000000000000100: n2899 = res_r;
      25'b0000000000000000000000010: n2899 = res_r;
      25'b0000000000000000000000001: n2899 = n2272;
      default: n2899 = 32'bX;
    endcase
  /*# cupu_fpu.vhd:258:9 */
  always @*
    case (n2803)
      25'b1000000000000000000000000: n2903 = 1'b1;
      25'b0100000000000000000000000: n2903 = 1'b0;
      25'b0010000000000000000000000: n2903 = 1'b0;
      25'b0001000000000000000000000: n2903 = 1'b0;
      25'b0000100000000000000000000: n2903 = 1'b0;
      25'b0000010000000000000000000: n2903 = 1'b0;
      25'b0000001000000000000000000: n2903 = 1'b0;
      25'b0000000100000000000000000: n2903 = 1'b0;
      25'b0000000010000000000000000: n2903 = 1'b0;
      25'b0000000001000000000000000: n2903 = 1'b0;
      25'b0000000000100000000000000: n2903 = 1'b0;
      25'b0000000000010000000000000: n2903 = 1'b0;
      25'b0000000000001000000000000: n2903 = 1'b0;
      25'b0000000000000100000000000: n2903 = 1'b0;
      25'b0000000000000010000000000: n2903 = 1'b0;
      25'b0000000000000001000000000: n2903 = 1'b0;
      25'b0000000000000000100000000: n2903 = 1'b0;
      25'b0000000000000000010000000: n2903 = 1'b0;
      25'b0000000000000000001000000: n2903 = 1'b0;
      25'b0000000000000000000100000: n2903 = 1'b0;
      25'b0000000000000000000010000: n2903 = 1'b0;
      25'b0000000000000000000001000: n2903 = 1'b0;
      25'b0000000000000000000000100: n2903 = 1'b0;
      25'b0000000000000000000000010: n2903 = 1'b0;
      25'b0000000000000000000000001: n2903 = 1'b0;
      default: n2903 = 1'bX;
    endcase
  /*# cupu_fpu.vhd:255:7 */
  assign n2925 = rst ? 5'b00000 : n2816;
  /*# cupu_fpu.vhd:255:7 */
  assign n2926 = rst ? cont : n2821;
  /*# cupu_fpu.vhd:255:7 */
  assign n2927 = rst ? r : n2824;
  /*# cupu_fpu.vhd:255:7 */
  assign n2928 = {n2852, n2838};
  /*# cupu_fpu.vhd:255:7 */
  assign n2929 = rst ? x : n2928;
  /*# cupu_fpu.vhd:255:7 */
  assign n2930 = rst ? y : n2854;
  /*# cupu_fpu.vhd:255:7 */
  assign n2931 = rst ? z : n2857;
  /*# cupu_fpu.vhd:255:7 */
  assign n2932 = {n2869, n2863};
  /*# cupu_fpu.vhd:255:7 */
  assign n2933 = rst ? w : n2932;
  /*# cupu_fpu.vhd:255:7 */
  assign n2934 = rst ? ma : n2871;
  /*# cupu_fpu.vhd:255:7 */
  assign n2935 = rst ? mb : n2873;
  /*# cupu_fpu.vhd:255:7 */
  assign n2936 = rst ? ea : n2875;
  /*# cupu_fpu.vhd:255:7 */
  assign n2937 = rst ? eb : n2877;
  /*# cupu_fpu.vhd:255:7 */
  assign n2938 = rst ? er : n2881;
  /*# cupu_fpu.vhd:255:7 */
  assign n2939 = rst ? ed : n2883;
  /*# cupu_fpu.vhd:255:7 */
  assign n2940 = rst ? sr : n2885;
  /*# cupu_fpu.vhd:255:7 */
  assign n2941 = rst ? stk : n2889;
  /*# cupu_fpu.vhd:255:7 */
  assign n2942 = rst ? effsub : n2891;
  /*# cupu_fpu.vhd:255:7 */
  assign n2943 = rst ? cnt : n2895;
  /*# cupu_fpu.vhd:255:7 */
  assign n2944 = rst ? quad : n2897;
  /*# cupu_fpu.vhd:255:7 */
  assign n2945 = rst ? res_r : n2899;
  /*# cupu_fpu.vhd:255:7 */
  assign n2947 = rst ? 1'b0 : n2903;
  /*# cupu_fpu.vhd:89:10 */
  assign n2990 = {n1606, n1613};
  /*# cupu_fpu.vhd:89:15 */
  assign n2991 = {n1611, n1614};
  /*# cupu_fpu.vhd:97:17 */
  assign n2992 = {n1894, n1880};
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n2993 <= n2925;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n2994 <= n2926;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n2995 <= n2927;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n2996 <= n2929;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n2997 <= n2930;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n2998 <= n2931;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n2999 <= n2933;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3000 <= n2934;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3001 <= n2935;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3002 <= n2936;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3003 <= n2937;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3004 <= n2938;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3005 <= n2939;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3006 <= n2940;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3007 <= n2941;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3008 <= n2942;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3009 <= n2943;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3010 <= n2944;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3011 <= n2945;
  /*# cupu_fpu.vhd:253:5 */
  always @(posedge clk)
    n3012 <= n2947;
  /*# cupu_fpu.vhd:141:26 */
  reg [65:0] n3013[20:0] ; // memory
  initial begin
    n3013[20] = 66'b000000000000000000000000111111111111111111111111111111111111111111;
    n3013[19] = 66'b000000000000000000000001111111111111111111111111111111111111110101;
    n3013[18] = 66'b000000000000000000000011111111111111111111111111111111111110101011;
    n3013[17] = 66'b000000000000000000000111111111111111111111111111111111110101010101;
    n3013[16] = 66'b000000000000000000001111111111111111111111111111111110101010101011;
    n3013[15] = 66'b000000000000000000011111111111111111111111111111110101010101010101;
    n3013[14] = 66'b000000000000000000111111111111111111111111111110101010101010101011;
    n3013[13] = 66'b000000000000000001111111111111111111111111110101010101010101010101;
    n3013[12] = 66'b000000000000000011111111111111111111111110101010101010101010101011;
    n3013[11] = 66'b000000000000000111111111111111111111110101010101010101010101101111;
    n3013[10] = 66'b000000000000001111111111111111111110101010101010101010110111011110;
    n3013[9] = 66'b000000000000011111111111111111110101010101010101011011101110111100;
    n3013[8] = 66'b000000000000111111111111111110101010101010101101110111011101101110;
    n3013[7] = 66'b000000000001111111111111110101010101010110111011101110101001011101;
    n3013[6] = 66'b000000000011111111111110101010101011011101110110111001010011010110;
    n3013[5] = 66'b000000000111111111110101010101101110111010100101110110001001001011;
    n3013[4] = 66'b000000001111111110101010110111011011100101100111111011110100111001;
    n3013[3] = 66'b000000011111110101011011101010011010101011000010111101101101110010;
    n3013[2] = 66'b000000111110101101101110101111110010010110010000000110111010110001;
    n3013[1] = 66'b000001110110101100011001110000010101100001101110110100111101101001;
    n3013[0] = 66'b000011001001000011111101101010100010001000010110100011000010001101;
    end
  assign n3015 = n3013[n1740];
  /*# cupu_fpu.vhd:141:26 */
  /*# cupu_fpu.vhd:141:25 */
  reg n3016[199:0] ; // memory
  initial begin
    n3016[199] = 1'b1;
    n3016[198] = 1'b0;
    n3016[197] = 1'b1;
    n3016[196] = 1'b0;
    n3016[195] = 1'b0;
    n3016[194] = 1'b0;
    n3016[193] = 1'b1;
    n3016[192] = 1'b0;
    n3016[191] = 1'b1;
    n3016[190] = 1'b1;
    n3016[189] = 1'b1;
    n3016[188] = 1'b1;
    n3016[187] = 1'b1;
    n3016[186] = 1'b0;
    n3016[185] = 1'b0;
    n3016[184] = 1'b1;
    n3016[183] = 1'b1;
    n3016[182] = 1'b0;
    n3016[181] = 1'b0;
    n3016[180] = 1'b0;
    n3016[179] = 1'b0;
    n3016[178] = 1'b0;
    n3016[177] = 1'b1;
    n3016[176] = 1'b1;
    n3016[175] = 1'b0;
    n3016[174] = 1'b1;
    n3016[173] = 1'b1;
    n3016[172] = 1'b0;
    n3016[171] = 1'b1;
    n3016[170] = 1'b1;
    n3016[169] = 1'b1;
    n3016[168] = 1'b0;
    n3016[167] = 1'b0;
    n3016[166] = 1'b1;
    n3016[165] = 1'b0;
    n3016[164] = 1'b0;
    n3016[163] = 1'b1;
    n3016[162] = 1'b1;
    n3016[161] = 1'b1;
    n3016[160] = 1'b0;
    n3016[159] = 1'b0;
    n3016[158] = 1'b1;
    n3016[157] = 1'b0;
    n3016[156] = 1'b0;
    n3016[155] = 1'b0;
    n3016[154] = 1'b1;
    n3016[153] = 1'b0;
    n3016[152] = 1'b0;
    n3016[151] = 1'b0;
    n3016[150] = 1'b0;
    n3016[149] = 1'b0;
    n3016[148] = 1'b1;
    n3016[147] = 1'b0;
    n3016[146] = 1'b1;
    n3016[145] = 1'b0;
    n3016[144] = 1'b1;
    n3016[143] = 1'b0;
    n3016[142] = 1'b0;
    n3016[141] = 1'b1;
    n3016[140] = 1'b0;
    n3016[139] = 1'b1;
    n3016[138] = 1'b0;
    n3016[137] = 1'b0;
    n3016[136] = 1'b1;
    n3016[135] = 1'b1;
    n3016[134] = 1'b1;
    n3016[133] = 1'b1;
    n3016[132] = 1'b1;
    n3016[131] = 1'b1;
    n3016[130] = 1'b1;
    n3016[129] = 1'b0;
    n3016[128] = 1'b0;
    n3016[127] = 1'b0;
    n3016[126] = 1'b0;
    n3016[125] = 1'b1;
    n3016[124] = 1'b0;
    n3016[123] = 1'b0;
    n3016[122] = 1'b1;
    n3016[121] = 1'b1;
    n3016[120] = 1'b1;
    n3016[119] = 1'b0;
    n3016[118] = 1'b1;
    n3016[117] = 1'b0;
    n3016[116] = 1'b1;
    n3016[115] = 1'b0;
    n3016[114] = 1'b1;
    n3016[113] = 1'b1;
    n3016[112] = 1'b1;
    n3016[111] = 1'b1;
    n3016[110] = 1'b1;
    n3016[109] = 1'b0;
    n3016[108] = 1'b1;
    n3016[107] = 1'b0;
    n3016[106] = 1'b0;
    n3016[105] = 1'b0;
    n3016[104] = 1'b1;
    n3016[103] = 1'b1;
    n3016[102] = 1'b1;
    n3016[101] = 1'b1;
    n3016[100] = 1'b1;
    n3016[99] = 1'b0;
    n3016[98] = 1'b1;
    n3016[97] = 1'b0;
    n3016[96] = 1'b1;
    n3016[95] = 1'b0;
    n3016[94] = 1'b0;
    n3016[93] = 1'b1;
    n3016[92] = 1'b1;
    n3016[91] = 1'b0;
    n3016[90] = 1'b1;
    n3016[89] = 1'b0;
    n3016[88] = 1'b0;
    n3016[87] = 1'b1;
    n3016[86] = 1'b1;
    n3016[85] = 1'b0;
    n3016[84] = 1'b1;
    n3016[83] = 1'b1;
    n3016[82] = 1'b1;
    n3016[81] = 1'b0;
    n3016[80] = 1'b1;
    n3016[79] = 1'b1;
    n3016[78] = 1'b1;
    n3016[77] = 1'b0;
    n3016[76] = 1'b0;
    n3016[75] = 1'b0;
    n3016[74] = 1'b0;
    n3016[73] = 1'b0;
    n3016[72] = 1'b0;
    n3016[71] = 1'b1;
    n3016[70] = 1'b1;
    n3016[69] = 1'b0;
    n3016[68] = 1'b1;
    n3016[67] = 1'b1;
    n3016[66] = 1'b0;
    n3016[65] = 1'b1;
    n3016[64] = 1'b1;
    n3016[63] = 1'b0;
    n3016[62] = 1'b1;
    n3016[61] = 1'b1;
    n3016[60] = 1'b0;
    n3016[59] = 1'b0;
    n3016[58] = 1'b0;
    n3016[57] = 1'b1;
    n3016[56] = 1'b0;
    n3016[55] = 1'b1;
    n3016[54] = 1'b0;
    n3016[53] = 1'b0;
    n3016[52] = 1'b1;
    n3016[51] = 1'b0;
    n3016[50] = 1'b1;
    n3016[49] = 1'b0;
    n3016[48] = 1'b1;
    n3016[47] = 1'b1;
    n3016[46] = 1'b0;
    n3016[45] = 1'b0;
    n3016[44] = 1'b1;
    n3016[43] = 1'b1;
    n3016[42] = 1'b0;
    n3016[41] = 1'b0;
    n3016[40] = 1'b1;
    n3016[39] = 1'b0;
    n3016[38] = 1'b0;
    n3016[37] = 1'b1;
    n3016[36] = 1'b1;
    n3016[35] = 1'b1;
    n3016[34] = 1'b1;
    n3016[33] = 1'b0;
    n3016[32] = 1'b0;
    n3016[31] = 1'b0;
    n3016[30] = 1'b1;
    n3016[29] = 1'b0;
    n3016[28] = 1'b0;
    n3016[27] = 1'b0;
    n3016[26] = 1'b0;
    n3016[25] = 1'b1;
    n3016[24] = 1'b1;
    n3016[23] = 1'b1;
    n3016[22] = 1'b0;
    n3016[21] = 1'b0;
    n3016[20] = 1'b1;
    n3016[19] = 1'b0;
    n3016[18] = 1'b0;
    n3016[17] = 1'b0;
    n3016[16] = 1'b0;
    n3016[15] = 1'b0;
    n3016[14] = 1'b1;
    n3016[13] = 1'b0;
    n3016[12] = 1'b0;
    n3016[11] = 1'b0;
    n3016[10] = 1'b0;
    n3016[9] = 1'b0;
    n3016[8] = 1'b1;
    n3016[7] = 1'b1;
    n3016[6] = 1'b1;
    n3016[5] = 1'b1;
    n3016[4] = 1'b1;
    n3016[3] = 1'b1;
    n3016[2] = 1'b1;
    n3016[1] = 1'b1;
    n3016[0] = 1'b0;
    end
  assign n3017 = n3016[n1802];
  /*# cupu_fpu.vhd:187:24 */
  /*# cupu_fpu.vhd:192:20 */
  reg n3018[64:0] ; // memory
  initial begin
    n3018[64] = 1'b1;
    n3018[63] = 1'b0;
    n3018[62] = 1'b0;
    n3018[61] = 1'b1;
    n3018[60] = 1'b0;
    n3018[59] = 1'b1;
    n3018[58] = 1'b1;
    n3018[57] = 1'b0;
    n3018[56] = 1'b0;
    n3018[55] = 1'b0;
    n3018[54] = 1'b1;
    n3018[53] = 1'b0;
    n3018[52] = 1'b0;
    n3018[51] = 1'b0;
    n3018[50] = 1'b0;
    n3018[49] = 1'b1;
    n3018[48] = 1'b1;
    n3018[47] = 1'b0;
    n3018[46] = 1'b0;
    n3018[45] = 1'b0;
    n3018[44] = 1'b1;
    n3018[43] = 1'b0;
    n3018[42] = 1'b1;
    n3018[41] = 1'b1;
    n3018[40] = 1'b0;
    n3018[39] = 1'b1;
    n3018[38] = 1'b0;
    n3018[37] = 1'b0;
    n3018[36] = 1'b0;
    n3018[35] = 1'b0;
    n3018[34] = 1'b1;
    n3018[33] = 1'b0;
    n3018[32] = 1'b0;
    n3018[31] = 1'b0;
    n3018[30] = 1'b1;
    n3018[29] = 1'b0;
    n3018[28] = 1'b0;
    n3018[27] = 1'b0;
    n3018[26] = 1'b1;
    n3018[25] = 1'b0;
    n3018[24] = 1'b1;
    n3018[23] = 1'b0;
    n3018[22] = 1'b1;
    n3018[21] = 1'b0;
    n3018[20] = 1'b1;
    n3018[19] = 1'b1;
    n3018[18] = 1'b0;
    n3018[17] = 1'b1;
    n3018[16] = 1'b1;
    n3018[15] = 1'b1;
    n3018[14] = 1'b1;
    n3018[13] = 1'b1;
    n3018[12] = 1'b1;
    n3018[11] = 1'b0;
    n3018[10] = 1'b0;
    n3018[9] = 1'b0;
    n3018[8] = 1'b0;
    n3018[7] = 1'b1;
    n3018[6] = 1'b0;
    n3018[5] = 1'b0;
    n3018[4] = 1'b1;
    n3018[3] = 1'b0;
    n3018[2] = 1'b0;
    n3018[1] = 1'b1;
    n3018[0] = 1'b1;
    end
  assign n3020 = n3018[n1813];
  /*# cupu_fpu.vhd:192:20 */
endmodule

module cupu_spi_Brtl
  (input  clk,
   input  rst,
   input  req,
   input  we,
   input  [1:0] size,
   input  [23:0] addr,
   input  [31:0] wdata,
   output [31:0] rdata,
   output done,
   output sck,
   output mosi,
   input  miso,
   output [1:0] cs_n);
  wire [1:0] state;
  wire [31:0] sreg;
  wire [5:0] bitcnt;
  wire sck_r;
  wire [1:0] cs_r;
  wire [1:0] gap;
  wire [5:0] last;
  wire n1441;
  wire n1444;
  wire n1447;
  wire [1:0] n1449;
  reg [5:0] n1450;
  wire [31:0] n1456;
  wire [31:0] n1458;
  wire [31:0] n1459;
  wire n1460;
  wire n1461;
  wire n1462;
  wire [1:0] n1463;
  wire [1:0] n1465;
  wire [31:0] n1466;
  wire [5:0] n1468;
  wire [1:0] n1469;
  wire n1471;
  wire n1472;
  wire [30:0] n1473;
  wire [31:0] n1474;
  wire n1475;
  wire [7:0] n1476;
  wire [31:0] n1478;
  wire n1480;
  wire [7:0] n1481;
  wire [23:0] n1483;
  wire [7:0] n1484;
  wire [31:0] n1485;
  wire n1487;
  wire [7:0] n1488;
  wire [7:0] n1489;
  wire [15:0] n1490;
  wire [7:0] n1491;
  wire [23:0] n1492;
  wire [7:0] n1493;
  wire [31:0] n1494;
  wire [1:0] n1495;
  reg [31:0] n1496;
  wire n1498;
  wire n1499;
  wire [7:0] n1500;
  wire [7:0] n1501;
  wire [15:0] n1502;
  wire [7:0] n1503;
  wire [23:0] n1504;
  wire [7:0] n1505;
  wire [31:0] n1506;
  wire [31:0] n1507;
  wire [5:0] n1509;
  wire [31:0] n1510;
  wire n1513;
  wire [1:0] n1515;
  wire [31:0] n1516;
  wire [5:0] n1517;
  wire [1:0] n1519;
  wire [1:0] n1521;
  wire [31:0] n1522;
  wire n1524;
  wire [1:0] n1525;
  wire [31:0] n1526;
  wire [5:0] n1527;
  wire n1530;
  wire [1:0] n1531;
  wire [1:0] n1532;
  wire n1535;
  wire n1537;
  wire [1:0] n1539;
  wire [1:0] n1541;
  wire [1:0] n1542;
  wire n1544;
  wire [2:0] n1545;
  reg [31:0] n1547;
  reg n1550;
  reg [1:0] n1552;
  reg [31:0] n1554;
  reg [5:0] n1556;
  reg n1558;
  reg [1:0] n1560;
  reg [1:0] n1562;
  wire [31:0] n1566;
  wire n1568;
  wire [1:0] n1571;
  wire [31:0] n1572;
  wire [5:0] n1573;
  wire n1575;
  wire [1:0] n1577;
  wire [1:0] n1578;
  reg [31:0] n1590;
  reg n1591;
  reg [1:0] n1592;
  reg [31:0] n1593;
  reg [5:0] n1594;
  reg n1595;
  reg [1:0] n1596;
  reg [1:0] n1597;
  assign rdata = n1590; //(module output)
  assign done = n1591; //(module output)
  assign sck = sck_r; //(module output)
  assign mosi = n1441; //(module output)
  assign cs_n = cs_r; //(module output)
  /*# cupu_spi.vhd:31:10 */
  assign state = n1592; // (signal)
  /*# cupu_spi.vhd:32:10 */
  assign sreg = n1593; // (signal)
  /*# cupu_spi.vhd:33:10 */
  assign bitcnt = n1594; // (signal)
  /*# cupu_spi.vhd:34:10 */
  assign sck_r = n1595; // (signal)
  /*# cupu_spi.vhd:35:10 */
  assign cs_r = n1596; // (signal)
  /*# cupu_spi.vhd:36:10 */
  assign gap = n1597; // (signal)
  /*# cupu_spi.vhd:37:10 */
  assign last = n1450; // (signal)
  /*# cupu_spi.vhd:40:15 */
  assign n1441 = sreg[31]; // extract
  /*# cupu_spi.vhd:45:24 */
  assign n1444 = size == 2'b00;
  /*# cupu_spi.vhd:46:24 */
  assign n1447 = size == 2'b01;
  /*# cupu_spi.vhd:44:3 */
  assign n1449 = {n1447, n1444};
  /*# cupu_spi.vhd:44:3 */
  always @*
    case (n1449)
      2'b10: n1450 = 6'b101111;
      2'b01: n1450 = 6'b100111;
      default: n1450 = 6'b111111;
    endcase
  /*# cupu_spi.vhd:64:31 */
  assign n1456 = {8'b00000010, addr};
  /*# cupu_spi.vhd:66:31 */
  assign n1458 = {8'b00000011, addr};
  /*# cupu_spi.vhd:63:15 */
  assign n1459 = we ? n1456 : n1458;
  /*# cupu_spi.vhd:68:34 */
  assign n1460 = addr[23]; // extract
  /*# cupu_spi.vhd:68:26 */
  assign n1461 = ~n1460;
  /*# cupu_spi.vhd:68:46 */
  assign n1462 = addr[23]; // extract
  /*# cupu_spi.vhd:68:40 */
  assign n1463 = {n1461, n1462};
  /*# cupu_spi.vhd:62:13 */
  assign n1465 = req ? 2'b01 : state;
  /*# cupu_spi.vhd:62:13 */
  assign n1466 = req ? n1459 : sreg;
  /*# cupu_spi.vhd:62:13 */
  assign n1468 = req ? 6'b000000 : bitcnt;
  /*# cupu_spi.vhd:62:13 */
  assign n1469 = req ? n1463 : cs_r;
  /*# cupu_spi.vhd:61:11 */
  assign n1471 = state == 2'b00;
  /*# cupu_spi.vhd:74:22 */
  assign n1472 = ~sck_r;
  /*# cupu_spi.vhd:79:25 */
  assign n1473 = sreg[30:0]; // extract
  /*# cupu_spi.vhd:79:39 */
  assign n1474 = {n1473, miso};
  /*# cupu_spi.vhd:80:25 */
  assign n1475 = bitcnt == last;
  /*# cupu_spi.vhd:82:57 */
  assign n1476 = n1474[7:0]; // extract
  /*# cupu_spi.vhd:82:53 */
  assign n1478 = {24'b000000000000000000000000, n1476};
  /*# cupu_spi.vhd:82:19 */
  assign n1480 = size == 2'b00;
  /*# cupu_spi.vhd:83:55 */
  assign n1481 = n1474[7:0]; // extract
  /*# cupu_spi.vhd:83:51 */
  assign n1483 = {16'b0000000000000000, n1481};
  /*# cupu_spi.vhd:83:72 */
  assign n1484 = n1474[15:8]; // extract
  /*# cupu_spi.vhd:83:68 */
  assign n1485 = {n1483, n1484};
  /*# cupu_spi.vhd:83:19 */
  assign n1487 = size == 2'b01;
  /*# cupu_spi.vhd:84:45 */
  assign n1488 = n1474[7:0]; // extract
  /*# cupu_spi.vhd:84:62 */
  assign n1489 = n1474[15:8]; // extract
  /*# cupu_spi.vhd:84:58 */
  assign n1490 = {n1488, n1489};
  /*# cupu_spi.vhd:84:80 */
  assign n1491 = n1474[23:16]; // extract
  /*# cupu_spi.vhd:84:76 */
  assign n1492 = {n1490, n1491};
  /*# cupu_spi.vhd:84:99 */
  assign n1493 = n1474[31:24]; // extract
  /*# cupu_spi.vhd:84:95 */
  assign n1494 = {n1492, n1493};
  /*# cupu_spi.vhd:81:17 */
  assign n1495 = {n1487, n1480};
  /*# cupu_spi.vhd:81:17 */
  always @*
    case (n1495)
      2'b10: n1496 = n1485;
      2'b01: n1496 = n1478;
      default: n1496 = n1494;
    endcase
  /*# cupu_spi.vhd:91:27 */
  assign n1498 = bitcnt == 6'b011111;
  /*# cupu_spi.vhd:91:32 */
  assign n1499 = we & n1498;
  /*# cupu_spi.vhd:92:32 */
  assign n1500 = wdata[7:0]; // extract
  /*# cupu_spi.vhd:92:52 */
  assign n1501 = wdata[15:8]; // extract
  /*# cupu_spi.vhd:92:45 */
  assign n1502 = {n1500, n1501};
  /*# cupu_spi.vhd:92:73 */
  assign n1503 = wdata[23:16]; // extract
  /*# cupu_spi.vhd:92:66 */
  assign n1504 = {n1502, n1503};
  /*# cupu_spi.vhd:92:95 */
  assign n1505 = wdata[31:24]; // extract
  /*# cupu_spi.vhd:92:88 */
  assign n1506 = {n1504, n1505};
  /*# cupu_spi.vhd:91:17 */
  assign n1507 = n1499 ? n1506 : n1474;
  /*# cupu_spi.vhd:96:34 */
  assign n1509 = bitcnt + 6'b000001;
  /*# cupu_spi.vhd:80:15 */
  assign n1510 = n1475 ? n1496 : n1590;
  /*# cupu_spi.vhd:80:15 */
  assign n1513 = n1475 ? 1'b1 : 1'b0;
  /*# cupu_spi.vhd:80:15 */
  assign n1515 = n1475 ? 2'b10 : state;
  /*# cupu_spi.vhd:80:15 */
  assign n1516 = n1475 ? sreg : n1507;
  /*# cupu_spi.vhd:80:15 */
  assign n1517 = n1475 ? bitcnt : n1509;
  /*# cupu_spi.vhd:80:15 */
  assign n1519 = n1475 ? 2'b11 : cs_r;
  /*# cupu_spi.vhd:80:15 */
  assign n1521 = n1475 ? 2'b11 : gap;
  /*# cupu_spi.vhd:74:13 */
  assign n1522 = n1472 ? n1590 : n1510;
  /*# cupu_spi.vhd:74:13 */
  assign n1524 = n1472 ? 1'b0 : n1513;
  /*# cupu_spi.vhd:74:13 */
  assign n1525 = n1472 ? state : n1515;
  /*# cupu_spi.vhd:74:13 */
  assign n1526 = n1472 ? sreg : n1516;
  /*# cupu_spi.vhd:74:13 */
  assign n1527 = n1472 ? bitcnt : n1517;
  /*# cupu_spi.vhd:74:13 */
  assign n1530 = n1472 ? 1'b1 : 1'b0;
  /*# cupu_spi.vhd:74:13 */
  assign n1531 = n1472 ? cs_r : n1519;
  /*# cupu_spi.vhd:74:13 */
  assign n1532 = n1472 ? gap : n1521;
  /*# cupu_spi.vhd:73:11 */
  assign n1535 = state == 2'b01;
  /*# cupu_spi.vhd:102:20 */
  assign n1537 = gap == 2'b00;
  /*# cupu_spi.vhd:105:26 */
  assign n1539 = gap - 2'b01;
  /*# cupu_spi.vhd:102:13 */
  assign n1541 = n1537 ? 2'b00 : state;
  /*# cupu_spi.vhd:102:13 */
  assign n1542 = n1537 ? gap : n1539;
  /*# cupu_spi.vhd:100:11 */
  assign n1544 = state == 2'b10;
  /*# cupu_spi.vhd:60:9 */
  assign n1545 = {n1544, n1535, n1471};
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1545)
      3'b100: n1547 = n1590;
      3'b010: n1547 = n1522;
      3'b001: n1547 = n1590;
      default: n1547 = 32'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1545)
      3'b100: n1550 = 1'b0;
      3'b010: n1550 = n1524;
      3'b001: n1550 = 1'b0;
      default: n1550 = 1'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1545)
      3'b100: n1552 = n1541;
      3'b010: n1552 = n1525;
      3'b001: n1552 = n1465;
      default: n1552 = 2'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1545)
      3'b100: n1554 = sreg;
      3'b010: n1554 = n1526;
      3'b001: n1554 = n1466;
      default: n1554 = 32'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1545)
      3'b100: n1556 = bitcnt;
      3'b010: n1556 = n1527;
      3'b001: n1556 = n1468;
      default: n1556 = 6'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1545)
      3'b100: n1558 = sck_r;
      3'b010: n1558 = n1530;
      3'b001: n1558 = sck_r;
      default: n1558 = 1'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1545)
      3'b100: n1560 = cs_r;
      3'b010: n1560 = n1531;
      3'b001: n1560 = n1469;
      default: n1560 = 2'bX;
    endcase
  /*# cupu_spi.vhd:60:9 */
  always @*
    case (n1545)
      3'b100: n1562 = n1542;
      3'b010: n1562 = n1532;
      3'b001: n1562 = gap;
      default: n1562 = 2'bX;
    endcase
  /*# cupu_spi.vhd:54:7 */
  assign n1566 = rst ? 32'b00000000000000000000000000000000 : n1547;
  /*# cupu_spi.vhd:54:7 */
  assign n1568 = rst ? 1'b0 : n1550;
  /*# cupu_spi.vhd:54:7 */
  assign n1571 = rst ? 2'b00 : n1552;
  /*# cupu_spi.vhd:54:7 */
  assign n1572 = rst ? sreg : n1554;
  /*# cupu_spi.vhd:54:7 */
  assign n1573 = rst ? bitcnt : n1556;
  /*# cupu_spi.vhd:54:7 */
  assign n1575 = rst ? 1'b0 : n1558;
  /*# cupu_spi.vhd:54:7 */
  assign n1577 = rst ? 2'b11 : n1560;
  /*# cupu_spi.vhd:54:7 */
  assign n1578 = rst ? gap : n1562;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1590 <= n1566;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1591 <= n1568;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1592 <= n1571;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1593 <= n1572;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1594 <= n1573;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1595 <= n1575;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1596 <= n1577;
  /*# cupu_spi.vhd:52:5 */
  always @(posedge clk)
    n1597 <= n1578;
endmodule

module cupu_core_Brtl_25000000
  (input  clk,
   input  rst,
   output mem_req,
   output mem_we,
   output [1:0] mem_size,
   output [23:0] mem_addr,
   output [31:0] mem_wdata,
   input  [31:0] mem_rdata,
   input  mem_done,
   input  [7:0] kbd_in,
   output [7:0] gpio_out,
   output halted);
  wire [1023:0] regs;
  wire [4:0] state;
  wire [31:0] pc;
  wire [31:0] ir;
  wire [31:0] opa;
  wire [31:0] opb;
  wire [31:0] acc;
  wire [4:0] cnt;
  wire flag;
  wire sgn_q;
  wire sgn_r;
  wire f_cond;
  wire [4:0] f_opc;
  wire [4:0] f_t;
  wire [4:0] f_a;
  wire [4:0] f_b;
  wire [10:0] f_fn;
  wire [4:0] op;
  wire [4:0] rf_idx;
  wire [31:0] rf_rd;
  wire [31:0] wb_val;
  wire [31:0] pc_inc;
  wire [32:0] add_x;
  wire [32:0] add_y;
  wire add_inv;
  wire add_cin;
  wire [33:0] add_s;
  wire [31:0] acc_addr;
  wire [1:0] acc_size;
  wire acc_req;
  wire mmio_sel;
  wire [31:0] mmio_rd;
  wire acc_done;
  wire [31:0] acc_rdata;
  wire fpu_start;
  wire [4:0] fpu_op;
  wire [31:0] fpu_res;
  wire fpu_done;
  wire [7:0] gpio;
  wire [31:0] seconds;
  wire ts_we;
  wire [2:0] kbd_sync;
  wire [6:0] kbd_data;
  wire kbd_valid;
  wire kbd_hit;
  wire kbd_take;
  wire [24:0] prescale;
  wire n34;
  wire [4:0] n35;
  wire [4:0] n36;
  wire [4:0] n37;
  wire [4:0] n38;
  wire [10:0] n39;
  wire n43;
  wire [30:0] n44;
  wire n46;
  wire n48;
  wire n50;
  wire n52;
  wire n54;
  wire n56;
  wire n58;
  wire n60;
  wire n62;
  wire n64;
  wire n66;
  wire n68;
  wire n70;
  wire n72;
  wire n75;
  wire n76;
  wire n77;
  wire n80;
  wire n81;
  wire n82;
  wire n85;
  wire n86;
  wire n87;
  wire n90;
  wire n91;
  wire n92;
  wire n94;
  wire [18:0] n95;
  reg [4:0] n116;
  wire [30:0] n117;
  wire n119;
  wire n121;
  wire n122;
  wire n124;
  wire n126;
  wire n127;
  wire n129;
  wire n131;
  wire n132;
  wire n134;
  wire n136;
  wire n138;
  wire n140;
  wire n141;
  wire n143;
  wire n145;
  wire n146;
  wire n148;
  wire n150;
  wire n151;
  wire n153;
  wire n155;
  wire n157;
  wire [10:0] n158;
  reg [4:0] n171;
  wire [4:0] n172;
  wire n176;
  wire [4:0] n177;
  wire n179;
  wire [4:0] n180;
  wire n184;
  wire [4:0] n187;
  wire [31:0] n191;
  wire n195;
  wire n197;
  wire n198;
  wire n200;
  wire n201;
  wire [31:0] n202;
  wire [31:0] n204;
  wire [32:0] n208;
  wire [32:0] n210;
  wire n212;
  wire n214;
  wire n215;
  wire n217;
  wire n218;
  wire n220;
  wire [1:0] n221;
  reg n224;
  reg n228;
  wire n230;
  wire [32:0] n232;
  wire [32:0] n234;
  wire n236;
  wire n237;
  wire [32:0] n238;
  wire n239;
  wire n240;
  wire [32:0] n241;
  wire n243;
  wire n246;
  wire n249;
  wire [32:0] n251;
  wire n253;
  wire n255;
  wire n257;
  wire [32:0] n259;
  wire n261;
  wire n263;
  wire n264;
  wire [32:0] n266;
  wire n268;
  wire n269;
  wire [32:0] n270;
  wire [32:0] n272;
  wire n274;
  wire [32:0] n276;
  wire n278;
  wire [6:0] n279;
  reg [32:0] n283;
  reg [32:0] n284;
  reg n290;
  reg n297;
  wire [32:0] n304;
  wire [32:0] n305;
  wire [33:0] n339;
  wire [33:0] n341;
  wire [33:0] n343;
  wire [33:0] n344;
  wire [33:0] n345;
  wire [4:0] n347;
  wire [4:0] n349;
  wire [3:0] n350;
  wire n354;
  wire [31:0] n355;
  wire n358;
  wire n360;
  wire n361;
  wire n362;
  wire n367;
  wire [2:0] n368;
  wire n370;
  wire n372;
  wire n373;
  wire n375;
  wire n377;
  wire n378;
  wire [1:0] n379;
  reg [1:0] n383;
  wire [1:0] n385;
  wire [7:0] n388;
  wire n390;
  wire n391;
  wire n393;
  wire n394;
  wire n397;
  wire n399;
  wire n400;
  wire n401;
  wire [23:0] n403;
  wire n404;
  wire n405;
  wire n406;
  wire n407;
  wire n408;
  wire n411;
  wire n413;
  wire n414;
  wire n415;
  wire n416;
  wire n417;
  wire [3:0] n423;
  wire [30:0] n424;
  wire n426;
  wire n428;
  wire [1:0] n429;
  reg [30:0] n433;
  wire [27:0] n434;
  wire n436;
  wire [31:0] n437;
  wire n439;
  wire n440;
  wire [31:0] n441;
  wire [31:0] n442;
  wire [31:0] n443;
  wire n445;
  wire n446;
  wire n448;
  wire n450;
  wire n451;
  wire n452;
  wire n453;
  wire n456;
  wire [3:0] n464;
  wire [4:0] n466;
  wire [4:0] n468;
  wire [27:0] n469;
  wire n471;
  wire [30:0] n472;
  wire [7:0] n473;
  wire n475;
  wire [7:0] n476;
  wire n478;
  wire [7:0] n479;
  wire n481;
  wire [7:0] n482;
  wire n484;
  wire [7:0] n486;
  wire n488;
  wire n490;
  wire [5:0] n491;
  reg [7:0] n493;
  wire [7:0] n495;
  wire [3:0] n499;
  wire [4:0] n501;
  wire [4:0] n503;
  wire [27:0] n504;
  wire n506;
  wire [30:0] n507;
  wire [7:0] n508;
  wire n510;
  wire [7:0] n511;
  wire n513;
  wire [7:0] n514;
  wire n516;
  wire [7:0] n517;
  wire n519;
  wire [7:0] n521;
  wire n523;
  wire n525;
  wire [5:0] n526;
  reg [7:0] n528;
  wire [7:0] n530;
  wire [3:0] n533;
  wire [4:0] n535;
  wire [4:0] n537;
  wire [27:0] n538;
  wire n540;
  wire [30:0] n541;
  wire [7:0] n542;
  wire n544;
  wire [7:0] n545;
  wire n547;
  wire [7:0] n548;
  wire n550;
  wire [7:0] n551;
  wire n553;
  wire [7:0] n555;
  wire n557;
  wire n559;
  wire [5:0] n560;
  reg [7:0] n562;
  wire [7:0] n564;
  wire [3:0] n567;
  wire [4:0] n569;
  wire [4:0] n571;
  wire [27:0] n572;
  wire n574;
  wire [30:0] n575;
  wire [7:0] n576;
  wire n578;
  wire [7:0] n579;
  wire n581;
  wire [7:0] n582;
  wire n584;
  wire [7:0] n585;
  wire n587;
  wire [7:0] n589;
  wire n591;
  wire n593;
  wire [5:0] n594;
  reg [7:0] n596;
  wire [7:0] n598;
  localparam [23:0] n600 = 24'b000000000000000000000000;
  wire n602;
  wire n605;
  wire [1:0] n606;
  wire [7:0] n607;
  reg [7:0] n608;
  wire [15:0] n609;
  wire [15:0] n610;
  reg [15:0] n611;
  wire [31:0] n612;
  wire n615;
  wire [31:0] n616;
  wire n619;
  wire n620;
  wire n624;
  wire n626;
  wire n627;
  wire n629;
  wire n630;
  wire n632;
  wire n633;
  wire n634;
  wire [31:0] n639;
  wire n641;
  wire [31:0] n643;
  wire [31:0] n644;
  wire [31:0] n646;
  wire [24:0] n647;
  wire [31:0] n648;
  wire [24:0] n650;
  wire [31:0] n651;
  wire [24:0] n653;
  wire [31:0] n655;
  wire [24:0] n657;
  wire [1:0] n664;
  wire n665;
  wire [2:0] n666;
  wire n667;
  wire n668;
  wire n669;
  wire n670;
  wire [6:0] n671;
  wire n673;
  wire [6:0] n674;
  wire n676;
  wire [2:0] n678;
  wire [6:0] n680;
  wire n682;
  wire n691;
  wire [4:0] n694;
  wire n699;
  wire n701;
  wire n702;
  wire n704;
  wire n705;
  wire [4:0] n708;
  wire [1023:0] n711;
  wire [1023:0] n712;
  wire n721;
  wire n722;
  wire n724;
  wire n727;
  wire n729;
  wire [4:0] n732;
  wire [31:0] n733;
  wire n735;
  wire n737;
  wire n739;
  wire [1:0] n740;
  wire n742;
  wire [15:0] n743;
  wire [31:0] n744;
  wire [15:0] n745;
  wire [31:0] n746;
  wire [31:0] n747;
  wire [31:0] n748;
  wire n750;
  wire n751;
  wire n752;
  wire [31:0] n753;
  wire n755;
  wire n757;
  wire n758;
  wire [31:0] n759;
  wire n761;
  wire [31:0] n762;
  wire n764;
  wire [31:0] n765;
  wire n767;
  wire [31:0] n768;
  wire n770;
  wire n771;
  wire [31:0] n803;
  wire n805;
  wire n806;
  wire n807;
  wire [31:0] n839;
  wire n841;
  wire n843;
  wire [15:0] n844;
  wire [31:0] n846;
  wire n848;
  wire [2:0] n849;
  wire n851;
  wire n852;
  wire n854;
  wire n855;
  wire n856;
  wire n858;
  wire n860;
  wire n861;
  wire n863;
  wire n864;
  wire n865;
  wire [4:0] n866;
  reg n867;
  wire n869;
  wire n871;
  wire n873;
  wire n874;
  wire n876;
  wire [4:0] n879;
  wire n881;
  wire n883;
  wire n884;
  wire n886;
  wire n887;
  wire [26:0] n888;
  wire n890;
  wire [4:0] n891;
  wire [4:0] n894;
  wire [31:0] n896;
  wire [4:0] n897;
  wire n899;
  wire n901;
  wire n902;
  wire n904;
  wire n906;
  wire n907;
  wire [31:0] n908;
  wire n910;
  wire [31:0] n911;
  wire n913;
  wire n915;
  wire n917;
  wire [17:0] n918;
  reg [4:0] n929;
  reg [31:0] n931;
  reg [31:0] n933;
  reg [31:0] n936;
  reg [4:0] n939;
  reg n941;
  reg n945;
  wire [4:0] n947;
  wire [31:0] n949;
  wire [31:0] n950;
  wire [31:0] n951;
  wire [4:0] n952;
  wire n953;
  wire n955;
  wire n957;
  wire [31:0] n958;
  wire n960;
  wire [31:0] n961;
  wire n962;
  wire [30:0] n963;
  wire [31:0] n964;
  wire [4:0] n966;
  wire n968;
  wire [4:0] n970;
  wire n972;
  wire n973;
  wire n974;
  wire n975;
  wire n976;
  wire n977;
  wire n978;
  wire n979;
  wire n980;
  wire [31:0] n981;
  wire [31:0] n982;
  wire n984;
  wire n985;
  wire n986;
  wire [31:0] n987;
  wire [31:0] n988;
  wire n990;
  wire [31:0] n991;
  wire [30:0] n992;
  wire n993;
  wire [31:0] n994;
  wire [31:0] n995;
  wire [30:0] n996;
  wire [31:0] n997;
  wire [4:0] n999;
  wire n1001;
  wire [4:0] n1003;
  wire n1005;
  wire [31:0] n1006;
  wire [31:0] n1007;
  wire n1009;
  wire [31:0] n1010;
  wire [31:0] n1011;
  wire n1013;
  wire n1015;
  wire n1016;
  wire n1017;
  wire [30:0] n1018;
  wire [31:0] n1020;
  wire [30:0] n1021;
  wire [31:0] n1023;
  wire [31:0] n1024;
  wire [4:0] n1026;
  wire [4:0] n1028;
  wire [31:0] n1029;
  wire [4:0] n1030;
  wire n1032;
  wire n1034;
  wire n1036;
  wire n1037;
  wire [7:0] n1038;
  wire [7:0] n1039;
  wire [4:0] n1042;
  wire [31:0] n1043;
  wire [7:0] n1044;
  wire [4:0] n1045;
  wire n1046;
  wire [7:0] n1047;
  wire n1049;
  wire n1051;
  wire n1053;
  wire n1054;
  wire n1056;
  wire [4:0] n1058;
  wire [31:0] n1059;
  wire n1061;
  wire [4:0] n1063;
  wire n1065;
  wire [4:0] n1067;
  wire n1069;
  wire n1071;
  wire [17:0] n1072;
  reg [4:0] n1083;
  reg [31:0] n1085;
  reg [31:0] n1087;
  reg [31:0] n1089;
  reg [31:0] n1091;
  reg [31:0] n1094;
  reg [4:0] n1097;
  reg n1099;
  reg n1101;
  reg n1103;
  reg n1106;
  reg [7:0] n1108;
  wire [4:0] n1110;
  wire [31:0] n1112;
  wire [31:0] n1113;
  wire [31:0] n1114;
  wire [31:0] n1115;
  wire [31:0] n1116;
  wire [4:0] n1118;
  wire n1120;
  wire n1121;
  wire n1122;
  wire n1124;
  wire [7:0] n1127;
  reg [1023:0] n1147;
  reg [4:0] n1148;
  reg [31:0] n1149;
  reg [31:0] n1150;
  reg [31:0] n1151;
  reg [31:0] n1152;
  reg [31:0] n1153;
  reg [4:0] n1154;
  reg n1155;
  reg n1156;
  reg n1157;
  reg n1158;
  reg [7:0] n1159;
  reg [31:0] n1160;
  reg [2:0] n1161;
  reg [6:0] n1162;
  reg n1163;
  reg [24:0] n1164;
  wire [31:0] n1165;
  wire n1166;
  wire n1167;
  wire n1168;
  wire n1169;
  wire n1170;
  wire n1171;
  wire n1172;
  wire n1173;
  wire n1174;
  wire n1175;
  wire n1176;
  wire n1177;
  wire n1178;
  wire n1179;
  wire n1180;
  wire n1181;
  wire n1182;
  wire n1183;
  wire n1184;
  wire n1185;
  wire n1186;
  wire n1187;
  wire n1188;
  wire n1189;
  wire n1190;
  wire n1191;
  wire n1192;
  wire n1193;
  wire n1194;
  wire n1195;
  wire n1196;
  wire n1197;
  wire n1198;
  wire n1199;
  wire n1200;
  wire n1201;
  wire n1202;
  wire n1203;
  wire n1204;
  wire n1205;
  wire n1206;
  wire n1207;
  wire n1208;
  wire n1209;
  wire n1210;
  wire n1211;
  wire n1212;
  wire n1213;
  wire n1214;
  wire n1215;
  wire n1216;
  wire n1217;
  wire n1218;
  wire n1219;
  wire n1220;
  wire n1221;
  wire n1222;
  wire n1223;
  wire n1224;
  wire n1225;
  wire n1226;
  wire n1227;
  wire n1228;
  wire n1229;
  wire n1230;
  wire n1231;
  wire n1232;
  wire n1233;
  wire n1234;
  wire n1235;
  wire [31:0] n1236;
  wire [31:0] n1237;
  wire [31:0] n1238;
  wire [31:0] n1239;
  wire [31:0] n1240;
  wire [31:0] n1241;
  wire [31:0] n1242;
  wire [31:0] n1243;
  wire [31:0] n1244;
  wire [31:0] n1245;
  wire [31:0] n1246;
  wire [31:0] n1247;
  wire [31:0] n1248;
  wire [31:0] n1249;
  wire [31:0] n1250;
  wire [31:0] n1251;
  wire [31:0] n1252;
  wire [31:0] n1253;
  wire [31:0] n1254;
  wire [31:0] n1255;
  wire [31:0] n1256;
  wire [31:0] n1257;
  wire [31:0] n1258;
  wire [31:0] n1259;
  wire [31:0] n1260;
  wire [31:0] n1261;
  wire [31:0] n1262;
  wire [31:0] n1263;
  wire [31:0] n1264;
  wire [31:0] n1265;
  wire [31:0] n1266;
  wire [31:0] n1267;
  wire [31:0] n1268;
  wire [31:0] n1269;
  wire [31:0] n1270;
  wire [31:0] n1271;
  wire [31:0] n1272;
  wire [31:0] n1273;
  wire [31:0] n1274;
  wire [31:0] n1275;
  wire [31:0] n1276;
  wire [31:0] n1277;
  wire [31:0] n1278;
  wire [31:0] n1279;
  wire [31:0] n1280;
  wire [31:0] n1281;
  wire [31:0] n1282;
  wire [31:0] n1283;
  wire [31:0] n1284;
  wire [31:0] n1285;
  wire [31:0] n1286;
  wire [31:0] n1287;
  wire [31:0] n1288;
  wire [31:0] n1289;
  wire [31:0] n1290;
  wire [31:0] n1291;
  wire [31:0] n1292;
  wire [31:0] n1293;
  wire [31:0] n1294;
  wire [31:0] n1295;
  wire [31:0] n1296;
  wire [31:0] n1297;
  wire [31:0] n1298;
  wire [31:0] n1299;
  wire [1023:0] n1300;
  wire n1301;
  wire n1302;
  wire n1303;
  wire n1304;
  wire n1305;
  wire n1306;
  wire n1307;
  wire n1308;
  wire n1309;
  wire n1310;
  wire n1311;
  wire n1312;
  wire n1313;
  wire n1314;
  wire n1315;
  wire n1316;
  wire n1317;
  wire n1318;
  wire n1319;
  wire n1320;
  wire n1321;
  wire n1322;
  wire n1323;
  wire n1324;
  wire n1325;
  wire n1326;
  wire n1327;
  wire n1328;
  wire n1329;
  wire n1330;
  wire n1331;
  wire n1332;
  wire n1333;
  wire n1334;
  wire n1335;
  wire n1336;
  wire n1337;
  wire n1338;
  wire n1339;
  wire n1340;
  wire n1341;
  wire n1342;
  wire n1343;
  wire n1344;
  wire n1345;
  wire n1346;
  wire n1347;
  wire n1348;
  wire n1349;
  wire n1350;
  wire n1351;
  wire n1352;
  wire n1353;
  wire n1354;
  wire n1355;
  wire n1356;
  wire n1357;
  wire n1358;
  wire n1359;
  wire n1360;
  wire n1361;
  wire n1362;
  wire n1363;
  wire n1364;
  wire n1365;
  wire n1366;
  wire n1367;
  wire n1368;
  wire n1369;
  wire n1370;
  wire [31:0] n1371;
  wire [31:0] n1372;
  wire [31:0] n1373;
  wire [31:0] n1374;
  wire [31:0] n1375;
  wire [31:0] n1376;
  wire [31:0] n1377;
  wire [31:0] n1378;
  wire [31:0] n1379;
  wire [31:0] n1380;
  wire [31:0] n1381;
  wire [31:0] n1382;
  wire [31:0] n1383;
  wire [31:0] n1384;
  wire [31:0] n1385;
  wire [31:0] n1386;
  wire [31:0] n1387;
  wire [31:0] n1388;
  wire [31:0] n1389;
  wire [31:0] n1390;
  wire [31:0] n1391;
  wire [31:0] n1392;
  wire [31:0] n1393;
  wire [31:0] n1394;
  wire [31:0] n1395;
  wire [31:0] n1396;
  wire [31:0] n1397;
  wire [31:0] n1398;
  wire [31:0] n1399;
  wire [31:0] n1400;
  wire [31:0] n1401;
  wire [31:0] n1402;
  wire [31:0] n1403;
  wire [31:0] n1404;
  wire [31:0] n1405;
  wire [31:0] n1406;
  wire [31:0] n1407;
  wire [31:0] n1408;
  wire [31:0] n1409;
  wire [31:0] n1410;
  wire [31:0] n1411;
  wire [31:0] n1412;
  wire [31:0] n1413;
  wire [31:0] n1414;
  wire [31:0] n1415;
  wire [31:0] n1416;
  wire [31:0] n1417;
  wire [31:0] n1418;
  wire [31:0] n1419;
  wire [31:0] n1420;
  wire [31:0] n1421;
  wire [31:0] n1422;
  wire [31:0] n1423;
  wire [31:0] n1424;
  wire [31:0] n1425;
  wire [31:0] n1426;
  wire [31:0] n1427;
  wire [31:0] n1428;
  wire [31:0] n1429;
  wire [31:0] n1430;
  wire [31:0] n1431;
  wire [31:0] n1432;
  wire [31:0] n1433;
  wire [31:0] n1434;
  wire [1023:0] n1435;
  assign mem_req = n394; //(module output)
  assign mem_we = n401; //(module output)
  assign mem_size = acc_size; //(module output)
  assign mem_addr = n403; //(module output)
  assign mem_wdata = opb; //(module output)
  assign gpio_out = gpio; //(module output)
  assign halted = n620; //(module output)
  /*# cupu_core.vhd:54:10 */
  assign regs = n1147; // (signal)
  /*# cupu_core.vhd:55:10 */
  assign state = n1148; // (signal)
  /*# cupu_core.vhd:56:10 */
  assign pc = n1149; // (signal)
  /*# cupu_core.vhd:56:14 */
  assign ir = n1150; // (signal)
  /*# cupu_core.vhd:56:18 */
  assign opa = n1151; // (signal)
  /*# cupu_core.vhd:56:23 */
  assign opb = n1152; // (signal)
  /*# cupu_core.vhd:56:28 */
  assign acc = n1153; // (signal)
  /*# cupu_core.vhd:57:10 */
  assign cnt = n1154; // (signal)
  /*# cupu_core.vhd:58:10 */
  assign flag = n1155; // (signal)
  /*# cupu_core.vhd:58:16 */
  assign sgn_q = n1156; // (signal)
  /*# cupu_core.vhd:58:23 */
  assign sgn_r = n1157; // (signal)
  /*# cupu_core.vhd:61:10 */
  assign f_cond = n34; // (signal)
  /*# cupu_core.vhd:62:10 */
  assign f_opc = n35; // (signal)
  /*# cupu_core.vhd:63:10 */
  assign f_t = n36; // (signal)
  /*# cupu_core.vhd:63:15 */
  assign f_a = n37; // (signal)
  /*# cupu_core.vhd:63:20 */
  assign f_b = n38; // (signal)
  /*# cupu_core.vhd:64:10 */
  assign f_fn = n39; // (signal)
  /*# cupu_core.vhd:65:10 */
  assign op = n172; // (signal)
  /*# cupu_core.vhd:67:10 */
  assign rf_idx = n177; // (signal)
  /*# cupu_core.vhd:68:10 */
  assign rf_rd = n191; // (signal)
  /*# cupu_core.vhd:69:10 */
  assign wb_val = n202; // (signal)
  /*# cupu_core.vhd:70:10 */
  assign pc_inc = n204; // (signal)
  /*# cupu_core.vhd:73:10 */
  assign add_x = n283; // (signal)
  /*# cupu_core.vhd:73:17 */
  assign add_y = n284; // (signal)
  /*# cupu_core.vhd:74:10 */
  assign add_inv = n290; // (signal)
  /*# cupu_core.vhd:74:19 */
  assign add_cin = n297; // (signal)
  /*# cupu_core.vhd:75:10 */
  assign add_s = n345; // (signal)
  /*# cupu_core.vhd:78:10 */
  assign acc_addr = n355; // (signal)
  /*# cupu_core.vhd:79:10 */
  assign acc_size = n385; // (signal)
  /*# cupu_core.vhd:80:10 */
  assign acc_req = n362; // (signal)
  /*# cupu_core.vhd:81:10 */
  assign mmio_sel = n391; // (signal)
  /*# cupu_core.vhd:82:10 */
  assign mmio_rd = n612; // (signal)
  /*# cupu_core.vhd:83:10 */
  assign acc_done = n405; // (signal)
  /*# cupu_core.vhd:84:10 */
  assign acc_rdata = n616; // (signal)
  /*# cupu_core.vhd:87:10 */
  assign fpu_start = n1158; // (signal)
  /*# cupu_core.vhd:88:10 */
  assign fpu_op = n349; // (signal)
  /*# cupu_core.vhd:93:10 */
  assign gpio = n1159; // (signal)
  /*# cupu_core.vhd:94:10 */
  assign seconds = n1160; // (signal)
  /*# cupu_core.vhd:95:10 */
  assign ts_we = n634; // (signal)
  /*# cupu_core.vhd:96:10 */
  assign kbd_sync = n1161; // (signal)
  /*# cupu_core.vhd:97:10 */
  assign kbd_data = n1162; // (signal)
  /*# cupu_core.vhd:98:10 */
  assign kbd_valid = n1163; // (signal)
  /*# cupu_core.vhd:99:10 */
  assign kbd_hit = n456; // (signal)
  /*# cupu_core.vhd:100:10 */
  assign kbd_take = n417; // (signal)
  /*# cupu_core.vhd:101:10 */
  assign prescale = n1164; // (signal)
  /*# cupu_core.vhd:103:15 */
  assign n34 = ir[31]; // extract
  /*# cupu_core.vhd:104:15 */
  assign n35 = ir[30:26]; // extract
  /*# cupu_core.vhd:105:15 */
  assign n36 = ir[25:21]; // extract
  /*# cupu_core.vhd:106:15 */
  assign n37 = ir[20:16]; // extract
  /*# cupu_core.vhd:107:15 */
  assign n38 = ir[15:11]; // extract
  /*# cupu_core.vhd:108:15 */
  assign n39 = ir[10:0]; // extract
  /*# cupu_core.vhd:116:14 */
  assign n43 = f_opc == 5'b00000;
  /*# cupu_core.vhd:117:12 */
  assign n44 = {20'b0, f_fn};  // uext
  /*# cupu_core.vhd:118:9 */
  assign n46 = n44 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:119:9 */
  assign n48 = n44 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:120:9 */
  assign n50 = n44 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:121:9 */
  assign n52 = n44 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:122:9 */
  assign n54 = n44 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:123:9 */
  assign n56 = n44 == 31'b0000000000000000000000000000101;
  /*# cupu_core.vhd:124:9 */
  assign n58 = n44 == 31'b0000000000000000000000000000110;
  /*# cupu_core.vhd:125:9 */
  assign n60 = n44 == 31'b0000000000000000000000000000111;
  /*# cupu_core.vhd:126:9 */
  assign n62 = n44 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:127:9 */
  assign n64 = n44 == 31'b0000000000000000000000000001001;
  /*# cupu_core.vhd:128:9 */
  assign n66 = n44 == 31'b0000000000000000000000000001010;
  /*# cupu_core.vhd:129:9 */
  assign n68 = n44 == 31'b0000000000000000000000000001011;
  /*# cupu_core.vhd:130:9 */
  assign n70 = n44 == 31'b0000000000000000000000000001100;
  /*# cupu_core.vhd:131:9 */
  assign n72 = n44 == 31'b0000000000000000000000000001101;
  /*# cupu_core.vhd:132:9 */
  assign n75 = $unsigned(n44) >= $unsigned(31'b0000000000000000000000000001110);
  /*# cupu_core.vhd:132:9 */
  assign n76 = $unsigned(n44) <= $unsigned(31'b0000000000000000000000000010111);
  /*# cupu_core.vhd:132:9 */
  assign n77 = n75 & n76;
  /*# cupu_core.vhd:133:9 */
  assign n80 = $unsigned(n44) >= $unsigned(31'b0000000000000000000000000100000);
  /*# cupu_core.vhd:133:9 */
  assign n81 = $unsigned(n44) <= $unsigned(31'b0000000000000000000000000100101);
  /*# cupu_core.vhd:133:9 */
  assign n82 = n80 & n81;
  /*# cupu_core.vhd:134:9 */
  assign n85 = $unsigned(n44) >= $unsigned(31'b0000000000000000000000000110000);
  /*# cupu_core.vhd:134:9 */
  assign n86 = $unsigned(n44) <= $unsigned(31'b0000000000000000000000000110010);
  /*# cupu_core.vhd:134:9 */
  assign n87 = n85 & n86;
  /*# cupu_core.vhd:135:9 */
  assign n90 = $unsigned(n44) >= $unsigned(31'b0000000000000000000000000110011);
  /*# cupu_core.vhd:135:9 */
  assign n91 = $unsigned(n44) <= $unsigned(31'b0000000000000000000000000110101);
  /*# cupu_core.vhd:135:9 */
  assign n92 = n90 & n91;
  /*# cupu_core.vhd:136:9 */
  assign n94 = n44 == 31'b0000000000000000000000001000000;
  /*# cupu_core.vhd:117:7 */
  assign n95 = {n94, n92, n87, n82, n77, n72, n70, n68, n66, n64, n62, n60, n58, n56, n54, n52, n50, n48, n46};
  /*# cupu_core.vhd:117:7 */
  always @*
    case (n95)
      19'b1000000000000000000: n116 = 5'b10100;
      19'b0100000000000000000: n116 = 5'b10011;
      19'b0010000000000000000: n116 = 5'b10010;
      19'b0001000000000000000: n116 = 5'b10001;
      19'b0000100000000000000: n116 = 5'b10000;
      19'b0000010000000000000: n116 = 5'b01111;
      19'b0000001000000000000: n116 = 5'b01110;
      19'b0000000100000000000: n116 = 5'b00100;
      19'b0000000010000000000: n116 = 5'b00111;
      19'b0000000001000000000: n116 = 5'b01101;
      19'b0000000000100000000: n116 = 5'b01100;
      19'b0000000000010000000: n116 = 5'b01011;
      19'b0000000000001000000: n116 = 5'b01010;
      19'b0000000000000100000: n116 = 5'b01001;
      19'b0000000000000010000: n116 = 5'b01000;
      19'b0000000000000001000: n116 = 5'b00101;
      19'b0000000000000000100: n116 = 5'b00011;
      19'b0000000000000000010: n116 = 5'b00010;
      19'b0000000000000000001: n116 = 5'b00001;
      default: n116 = 5'b00000;
    endcase
  /*# cupu_core.vhd:140:12 */
  assign n117 = {26'b0, f_opc};  // uext
  /*# cupu_core.vhd:141:9 */
  assign n119 = n117 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:141:21 */
  assign n121 = n117 == 31'b0000000000000000000000000011000;
  /*# cupu_core.vhd:141:21 */
  assign n122 = n119 | n121;
  /*# cupu_core.vhd:142:9 */
  assign n124 = n117 == 31'b0000000000000000000000000001001;
  /*# cupu_core.vhd:142:21 */
  assign n126 = n117 == 31'b0000000000000000000000000011001;
  /*# cupu_core.vhd:142:21 */
  assign n127 = n124 | n126;
  /*# cupu_core.vhd:143:9 */
  assign n129 = n117 == 31'b0000000000000000000000000001010;
  /*# cupu_core.vhd:143:21 */
  assign n131 = n117 == 31'b0000000000000000000000000011010;
  /*# cupu_core.vhd:143:21 */
  assign n132 = n129 | n131;
  /*# cupu_core.vhd:144:9 */
  assign n134 = n117 == 31'b0000000000000000000000000001011;
  /*# cupu_core.vhd:145:9 */
  assign n136 = n117 == 31'b0000000000000000000000000011011;
  /*# cupu_core.vhd:146:9 */
  assign n138 = n117 == 31'b0000000000000000000000000001100;
  /*# cupu_core.vhd:146:21 */
  assign n140 = n117 == 31'b0000000000000000000000000011100;
  /*# cupu_core.vhd:146:21 */
  assign n141 = n138 | n140;
  /*# cupu_core.vhd:147:9 */
  assign n143 = n117 == 31'b0000000000000000000000000001101;
  /*# cupu_core.vhd:147:21 */
  assign n145 = n117 == 31'b0000000000000000000000000011101;
  /*# cupu_core.vhd:147:21 */
  assign n146 = n143 | n145;
  /*# cupu_core.vhd:148:9 */
  assign n148 = n117 == 31'b0000000000000000000000000001110;
  /*# cupu_core.vhd:148:21 */
  assign n150 = n117 == 31'b0000000000000000000000000011110;
  /*# cupu_core.vhd:148:21 */
  assign n151 = n148 | n150;
  /*# cupu_core.vhd:149:9 */
  assign n153 = n117 == 31'b0000000000000000000000000001111;
  /*# cupu_core.vhd:150:9 */
  assign n155 = n117 == 31'b0000000000000000000000000010000;
  /*# cupu_core.vhd:151:9 */
  assign n157 = n117 == 31'b0000000000000000000000000010001;
  /*# cupu_core.vhd:140:7 */
  assign n158 = {n157, n155, n153, n151, n146, n141, n136, n134, n132, n127, n122};
  /*# cupu_core.vhd:140:7 */
  always @*
    case (n158)
      11'b10000000000: n171 = 5'b10111;
      11'b01000000000: n171 = 5'b10110;
      11'b00100000000: n171 = 5'b10101;
      11'b00010000000: n171 = 5'b01010;
      11'b00001000000: n171 = 5'b01001;
      11'b00000100000: n171 = 5'b01000;
      11'b00000010000: n171 = 5'b00110;
      11'b00000001000: n171 = 5'b00101;
      11'b00000000100: n171 = 5'b00011;
      11'b00000000010: n171 = 5'b00010;
      11'b00000000001: n171 = 5'b00001;
      default: n171 = 5'b00000;
    endcase
  /*# cupu_core.vhd:116:5 */
  assign n172 = n43 ? n116 : n171;
  /*# cupu_core.vhd:160:28 */
  assign n176 = state == 5'b00001;
  /*# cupu_core.vhd:160:17 */
  assign n177 = n176 ? f_a : n180;
  /*# cupu_core.vhd:161:25 */
  assign n179 = op == 5'b10011;
  /*# cupu_core.vhd:160:35 */
  assign n180 = n179 ? f_t : f_b;
  /*# cupu_core.vhd:166:15 */
  assign n184 = rf_idx != 5'b00000;
  /*# cupu_core.vhd:167:21 */
  assign n187 = 5'b11111 - rf_idx;
  /*# cupu_core.vhd:166:5 */
  assign n191 = n184 ? n1165 : 32'b00000000000000000000000000000000;
  /*# cupu_core.vhd:172:25 */
  assign n195 = op == 5'b00011;
  /*# cupu_core.vhd:172:40 */
  assign n197 = op == 5'b00101;
  /*# cupu_core.vhd:172:34 */
  assign n198 = n195 | n197;
  /*# cupu_core.vhd:172:55 */
  assign n200 = op == 5'b00110;
  /*# cupu_core.vhd:172:49 */
  assign n201 = n198 | n200;
  /*# cupu_core.vhd:172:17 */
  assign n202 = n201 ? opa : acc;
  /*# cupu_core.vhd:174:16 */
  assign n204 = pc + 32'b00000000000000000000000000000100;
  /*# cupu_core.vhd:181:20 */
  assign n208 = {1'b0, opa};
  /*# cupu_core.vhd:182:20 */
  assign n210 = {1'b0, opb};
  /*# cupu_core.vhd:188:11 */
  assign n212 = op == 5'b00010;
  /*# cupu_core.vhd:188:23 */
  assign n214 = op == 5'b01111;
  /*# cupu_core.vhd:188:23 */
  assign n215 = n212 | n214;
  /*# cupu_core.vhd:188:33 */
  assign n217 = op == 5'b10001;
  /*# cupu_core.vhd:188:33 */
  assign n218 = n215 | n217;
  /*# cupu_core.vhd:191:11 */
  assign n220 = op == 5'b01110;
  /*# cupu_core.vhd:187:9 */
  assign n221 = {n220, n218};
  /*# cupu_core.vhd:187:9 */
  always @*
    case (n221)
      2'b10: n224 = 1'b0;
      2'b01: n224 = 1'b1;
      default: n224 = 1'b0;
    endcase
  /*# cupu_core.vhd:187:9 */
  always @*
    case (n221)
      2'b10: n228 = 1'b1;
      2'b01: n228 = 1'b1;
      default: n228 = 1'b0;
    endcase
  /*# cupu_core.vhd:186:7 */
  assign n230 = state == 5'b00011;
  /*# cupu_core.vhd:196:22 */
  assign n232 = {1'b0, pc};
  /*# cupu_core.vhd:197:22 */
  assign n234 = {1'b0, opa};
  /*# cupu_core.vhd:195:7 */
  assign n236 = state == 5'b01000;
  /*# cupu_core.vhd:200:21 */
  assign n237 = acc[31]; // extract
  /*# cupu_core.vhd:200:26 */
  assign n238 = {n237, acc};
  /*# cupu_core.vhd:201:15 */
  assign n239 = opa[0]; // extract
  /*# cupu_core.vhd:202:23 */
  assign n240 = opb[31]; // extract
  /*# cupu_core.vhd:202:28 */
  assign n241 = {n240, opb};
  /*# cupu_core.vhd:203:18 */
  assign n243 = cnt == 5'b11111;
  /*# cupu_core.vhd:203:11 */
  assign n246 = n243 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:203:11 */
  assign n249 = n243 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:201:9 */
  assign n251 = n239 ? n241 : 33'b000000000000000000000000000000000;
  /*# cupu_core.vhd:201:9 */
  assign n253 = n239 ? n246 : 1'b0;
  /*# cupu_core.vhd:201:9 */
  assign n255 = n239 ? n249 : 1'b0;
  /*# cupu_core.vhd:198:7 */
  assign n257 = state == 5'b01001;
  /*# cupu_core.vhd:212:24 */
  assign n259 = {1'b0, opa};
  /*# cupu_core.vhd:210:7 */
  assign n261 = state == 5'b01010;
  /*# cupu_core.vhd:210:21 */
  assign n263 = state == 5'b01101;
  /*# cupu_core.vhd:210:21 */
  assign n264 = n261 | n263;
  /*# cupu_core.vhd:217:24 */
  assign n266 = {1'b0, opb};
  /*# cupu_core.vhd:215:7 */
  assign n268 = state == 5'b01011;
  /*# cupu_core.vhd:221:29 */
  assign n269 = opa[31]; // extract
  /*# cupu_core.vhd:221:24 */
  assign n270 = {acc, n269};
  /*# cupu_core.vhd:222:24 */
  assign n272 = {1'b0, opb};
  /*# cupu_core.vhd:220:7 */
  assign n274 = state == 5'b01100;
  /*# cupu_core.vhd:227:24 */
  assign n276 = {1'b0, acc};
  /*# cupu_core.vhd:225:7 */
  assign n278 = state == 5'b01110;
  /*# cupu_core.vhd:185:5 */
  assign n279 = {n278, n274, n268, n264, n257, n236, n230};
  /*# cupu_core.vhd:185:5 */
  always @*
    case (n279)
      7'b1000000: n283 = 33'b000000000000000000000000000000000;
      7'b0100000: n283 = n270;
      7'b0010000: n283 = 33'b000000000000000000000000000000000;
      7'b0001000: n283 = 33'b000000000000000000000000000000000;
      7'b0000100: n283 = n238;
      7'b0000010: n283 = n232;
      7'b0000001: n283 = n208;
      default: n283 = n208;
    endcase
  /*# cupu_core.vhd:185:5 */
  always @*
    case (n279)
      7'b1000000: n284 = n276;
      7'b0100000: n284 = n272;
      7'b0010000: n284 = n266;
      7'b0001000: n284 = n259;
      7'b0000100: n284 = n251;
      7'b0000010: n284 = n234;
      7'b0000001: n284 = n210;
      default: n284 = n210;
    endcase
  /*# cupu_core.vhd:185:5 */
  always @*
    case (n279)
      7'b1000000: n290 = 1'b1;
      7'b0100000: n290 = 1'b1;
      7'b0010000: n290 = 1'b1;
      7'b0001000: n290 = 1'b1;
      7'b0000100: n290 = n253;
      7'b0000010: n290 = 1'b0;
      7'b0000001: n290 = n224;
      default: n290 = 1'b0;
    endcase
  /*# cupu_core.vhd:185:5 */
  always @*
    case (n279)
      7'b1000000: n297 = 1'b1;
      7'b0100000: n297 = 1'b1;
      7'b0010000: n297 = 1'b1;
      7'b0001000: n297 = 1'b1;
      7'b0000100: n297 = n255;
      7'b0000010: n297 = 1'b0;
      7'b0000001: n297 = n228;
      default: n297 = 1'b0;
    endcase
  /*# cupu_core.vhd:240:12 */
  assign n304 = ~add_y;
  /*# cupu_core.vhd:239:5 */
  assign n305 = add_inv ? n304 : add_y;
  /*# cupu_core.vhd:242:10 */
  assign n339 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, add_cin};
  /*# cupu_core.vhd:243:19 */
  assign n341 = {1'b0, add_x};
  /*# cupu_core.vhd:243:35 */
  assign n343 = {1'b0, n305};
  /*# cupu_core.vhd:243:28 */
  assign n344 = n341 + n343;
  /*# cupu_core.vhd:243:40 */
  assign n345 = n344 + n339;
  /*# cupu_core.vhd:249:17 */
  assign n347 = f_fn[4:0]; // extract
  /*# cupu_core.vhd:249:30 */
  assign n349 = n347 - 5'b01110;
  /*# cupu_core.vhd:251:3 */
  cupu_fpu_Brtl fpu (
    .clk(clk),
    .rst(rst),
    .start(fpu_start),
    .op(n350),
    .a(opa),
    .b(opb),
    .res(fpu_res),
    .done(fpu_done));
  /*# cupu_core.vhd:256:22 */
  assign n350 = fpu_op[3:0]; // extract
  /*# cupu_core.vhd:266:29 */
  assign n354 = state == 5'b00000;
  /*# cupu_core.vhd:266:18 */
  assign n355 = n354 ? pc : opa;
  /*# cupu_core.vhd:267:30 */
  assign n358 = state == 5'b00000;
  /*# cupu_core.vhd:267:49 */
  assign n360 = state == 5'b00100;
  /*# cupu_core.vhd:267:40 */
  assign n361 = n358 | n360;
  /*# cupu_core.vhd:267:19 */
  assign n362 = n361 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:270:14 */
  assign n367 = state == 5'b00000;
  /*# cupu_core.vhd:273:16 */
  assign n368 = f_fn[2:0]; // extract
  /*# cupu_core.vhd:274:9 */
  assign n370 = n368 == 3'b000;
  /*# cupu_core.vhd:274:20 */
  assign n372 = n368 == 3'b011;
  /*# cupu_core.vhd:274:20 */
  assign n373 = n370 | n372;
  /*# cupu_core.vhd:275:9 */
  assign n375 = n368 == 3'b001;
  /*# cupu_core.vhd:275:20 */
  assign n377 = n368 == 3'b100;
  /*# cupu_core.vhd:275:20 */
  assign n378 = n375 | n377;
  /*# cupu_core.vhd:273:7 */
  assign n379 = {n378, n373};
  /*# cupu_core.vhd:273:7 */
  always @*
    case (n379)
      2'b10: n383 = 2'b01;
      2'b01: n383 = 2'b10;
      default: n383 = 2'b00;
    endcase
  /*# cupu_core.vhd:270:5 */
  assign n385 = n367 ? 2'b10 : n383;
  /*# cupu_core.vhd:281:33 */
  assign n388 = acc_addr[31:24]; // extract
  /*# cupu_core.vhd:281:48 */
  assign n390 = n388 == 8'b00000000;
  /*# cupu_core.vhd:281:20 */
  assign n391 = n390 ? 1'b0 : 1'b1;
  /*# cupu_core.vhd:282:28 */
  assign n393 = ~mmio_sel;
  /*# cupu_core.vhd:282:24 */
  assign n394 = acc_req & n393;
  /*# cupu_core.vhd:283:31 */
  assign n397 = state == 5'b00100;
  /*# cupu_core.vhd:283:46 */
  assign n399 = op == 5'b10011;
  /*# cupu_core.vhd:283:39 */
  assign n400 = n399 & n397;
  /*# cupu_core.vhd:283:20 */
  assign n401 = n400 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:285:41 */
  assign n403 = acc_addr[23:0]; // extract
  /*# cupu_core.vhd:288:39 */
  assign n404 = ~mmio_sel;
  /*# cupu_core.vhd:288:25 */
  assign n405 = n404 ? mem_done : n408;
  /*# cupu_core.vhd:288:67 */
  assign n406 = ~kbd_valid;
  /*# cupu_core.vhd:288:63 */
  assign n407 = kbd_hit & n406;
  /*# cupu_core.vhd:288:50 */
  assign n408 = ~n407;
  /*# cupu_core.vhd:289:31 */
  assign n411 = state == 5'b00100;
  /*# cupu_core.vhd:289:46 */
  assign n413 = op == 5'b10010;
  /*# cupu_core.vhd:289:39 */
  assign n414 = n413 & n411;
  /*# cupu_core.vhd:289:56 */
  assign n415 = kbd_hit & n414;
  /*# cupu_core.vhd:289:74 */
  assign n416 = kbd_valid & n415;
  /*# cupu_core.vhd:289:20 */
  assign n417 = n416 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:294:31 */
  assign n423 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:294:12 */
  assign n424 = {27'b0, n423};  // uext
  /*# cupu_core.vhd:296:7 */
  assign n426 = acc_size == 2'b00;
  /*# cupu_core.vhd:297:7 */
  assign n428 = acc_size == 2'b01;
  /*# cupu_core.vhd:295:5 */
  assign n429 = {n428, n426};
  /*# cupu_core.vhd:295:5 */
  always @*
    case (n429)
      2'b10: n433 = 31'b0000000000000000000000000000010;
      2'b01: n433 = 31'b0000000000000000000000000000001;
      default: n433 = 31'b0000000000000000000000000000100;
    endcase
  /*# cupu_core.vhd:301:16 */
  assign n434 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:301:30 */
  assign n436 = n434 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:301:50 */
  assign n437 = {1'b0, n424};  // uext
  /*# cupu_core.vhd:301:50 */
  assign n439 = $signed(n437) <= $signed(32'b00000000000000000000000000000100);
  /*# cupu_core.vhd:301:42 */
  assign n440 = n439 & n436;
  /*# cupu_core.vhd:301:63 */
  assign n441 = {1'b0, n424};  // uext
  /*# cupu_core.vhd:301:63 */
  assign n442 = {1'b0, n433};  // uext
  /*# cupu_core.vhd:301:63 */
  assign n443 = n441 + n442;
  /*# cupu_core.vhd:301:67 */
  assign n445 = $signed(n443) > $signed(32'b00000000000000000000000000000100);
  /*# cupu_core.vhd:301:55 */
  assign n446 = n445 & n440;
  /*# cupu_core.vhd:302:23 */
  assign n448 = state == 5'b00100;
  /*# cupu_core.vhd:302:38 */
  assign n450 = op == 5'b10011;
  /*# cupu_core.vhd:302:31 */
  assign n451 = n450 & n448;
  /*# cupu_core.vhd:302:12 */
  assign n452 = ~n451;
  /*# cupu_core.vhd:302:8 */
  assign n453 = n452 & n446;
  /*# cupu_core.vhd:301:5 */
  assign n456 = n453 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:315:29 */
  assign n464 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:315:19 */
  assign n466 = {1'b0, n464};
  /*# cupu_core.vhd:315:43 */
  assign n468 = n466 + 5'b00000;
  /*# cupu_core.vhd:317:18 */
  assign n469 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:317:32 */
  assign n471 = n469 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:318:14 */
  assign n472 = {26'b0, n468};  // uext
  /*# cupu_core.vhd:319:55 */
  assign n473 = seconds[7:0]; // extract
  /*# cupu_core.vhd:319:11 */
  assign n475 = n472 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:320:55 */
  assign n476 = seconds[15:8]; // extract
  /*# cupu_core.vhd:320:11 */
  assign n478 = n472 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:321:55 */
  assign n479 = seconds[23:16]; // extract
  /*# cupu_core.vhd:321:11 */
  assign n481 = n472 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:322:55 */
  assign n482 = seconds[31:24]; // extract
  /*# cupu_core.vhd:322:11 */
  assign n484 = n472 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:323:35 */
  assign n486 = {1'b0, kbd_data};
  /*# cupu_core.vhd:323:11 */
  assign n488 = n472 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:324:11 */
  assign n490 = n472 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:318:9 */
  assign n491 = {n490, n488, n484, n481, n478, n475};
  /*# cupu_core.vhd:318:9 */
  always @*
    case (n491)
      6'b100000: n493 = gpio;
      6'b010000: n493 = n486;
      6'b001000: n493 = n482;
      6'b000100: n493 = n479;
      6'b000010: n493 = n476;
      6'b000001: n493 = n473;
      default: n493 = 8'b00000000;
    endcase
  /*# cupu_core.vhd:317:7 */
  assign n495 = n471 ? n493 : 8'b00000000;
  /*# cupu_core.vhd:315:29 */
  assign n499 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:315:19 */
  assign n501 = {1'b0, n499};
  /*# cupu_core.vhd:315:43 */
  assign n503 = n501 + 5'b00001;
  /*# cupu_core.vhd:317:18 */
  assign n504 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:317:32 */
  assign n506 = n504 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:318:14 */
  assign n507 = {26'b0, n503};  // uext
  /*# cupu_core.vhd:319:55 */
  assign n508 = seconds[7:0]; // extract
  /*# cupu_core.vhd:319:11 */
  assign n510 = n507 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:320:55 */
  assign n511 = seconds[15:8]; // extract
  /*# cupu_core.vhd:320:11 */
  assign n513 = n507 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:321:55 */
  assign n514 = seconds[23:16]; // extract
  /*# cupu_core.vhd:321:11 */
  assign n516 = n507 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:322:55 */
  assign n517 = seconds[31:24]; // extract
  /*# cupu_core.vhd:322:11 */
  assign n519 = n507 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:323:35 */
  assign n521 = {1'b0, kbd_data};
  /*# cupu_core.vhd:323:11 */
  assign n523 = n507 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:324:11 */
  assign n525 = n507 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:318:9 */
  assign n526 = {n525, n523, n519, n516, n513, n510};
  /*# cupu_core.vhd:318:9 */
  always @*
    case (n526)
      6'b100000: n528 = gpio;
      6'b010000: n528 = n521;
      6'b001000: n528 = n517;
      6'b000100: n528 = n514;
      6'b000010: n528 = n511;
      6'b000001: n528 = n508;
      default: n528 = 8'b00000000;
    endcase
  /*# cupu_core.vhd:317:7 */
  assign n530 = n506 ? n528 : 8'b00000000;
  /*# cupu_core.vhd:315:29 */
  assign n533 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:315:19 */
  assign n535 = {1'b0, n533};
  /*# cupu_core.vhd:315:43 */
  assign n537 = n535 + 5'b00010;
  /*# cupu_core.vhd:317:18 */
  assign n538 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:317:32 */
  assign n540 = n538 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:318:14 */
  assign n541 = {26'b0, n537};  // uext
  /*# cupu_core.vhd:319:55 */
  assign n542 = seconds[7:0]; // extract
  /*# cupu_core.vhd:319:11 */
  assign n544 = n541 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:320:55 */
  assign n545 = seconds[15:8]; // extract
  /*# cupu_core.vhd:320:11 */
  assign n547 = n541 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:321:55 */
  assign n548 = seconds[23:16]; // extract
  /*# cupu_core.vhd:321:11 */
  assign n550 = n541 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:322:55 */
  assign n551 = seconds[31:24]; // extract
  /*# cupu_core.vhd:322:11 */
  assign n553 = n541 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:323:35 */
  assign n555 = {1'b0, kbd_data};
  /*# cupu_core.vhd:323:11 */
  assign n557 = n541 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:324:11 */
  assign n559 = n541 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:318:9 */
  assign n560 = {n559, n557, n553, n550, n547, n544};
  /*# cupu_core.vhd:318:9 */
  always @*
    case (n560)
      6'b100000: n562 = gpio;
      6'b010000: n562 = n555;
      6'b001000: n562 = n551;
      6'b000100: n562 = n548;
      6'b000010: n562 = n545;
      6'b000001: n562 = n542;
      default: n562 = 8'b00000000;
    endcase
  /*# cupu_core.vhd:317:7 */
  assign n564 = n540 ? n562 : 8'b00000000;
  /*# cupu_core.vhd:315:29 */
  assign n567 = acc_addr[3:0]; // extract
  /*# cupu_core.vhd:315:19 */
  assign n569 = {1'b0, n567};
  /*# cupu_core.vhd:315:43 */
  assign n571 = n569 + 5'b00011;
  /*# cupu_core.vhd:317:18 */
  assign n572 = acc_addr[31:4]; // extract
  /*# cupu_core.vhd:317:32 */
  assign n574 = n572 == 28'b0010000000000000000000000000;
  /*# cupu_core.vhd:318:14 */
  assign n575 = {26'b0, n571};  // uext
  /*# cupu_core.vhd:319:55 */
  assign n576 = seconds[7:0]; // extract
  /*# cupu_core.vhd:319:11 */
  assign n578 = n575 == 31'b0000000000000000000000000000000;
  /*# cupu_core.vhd:320:55 */
  assign n579 = seconds[15:8]; // extract
  /*# cupu_core.vhd:320:11 */
  assign n581 = n575 == 31'b0000000000000000000000000000001;
  /*# cupu_core.vhd:321:55 */
  assign n582 = seconds[23:16]; // extract
  /*# cupu_core.vhd:321:11 */
  assign n584 = n575 == 31'b0000000000000000000000000000010;
  /*# cupu_core.vhd:322:55 */
  assign n585 = seconds[31:24]; // extract
  /*# cupu_core.vhd:322:11 */
  assign n587 = n575 == 31'b0000000000000000000000000000011;
  /*# cupu_core.vhd:323:35 */
  assign n589 = {1'b0, kbd_data};
  /*# cupu_core.vhd:323:11 */
  assign n591 = n575 == 31'b0000000000000000000000000000100;
  /*# cupu_core.vhd:324:11 */
  assign n593 = n575 == 31'b0000000000000000000000000001000;
  /*# cupu_core.vhd:318:9 */
  assign n594 = {n593, n591, n587, n584, n581, n578};
  /*# cupu_core.vhd:318:9 */
  always @*
    case (n594)
      6'b100000: n596 = gpio;
      6'b010000: n596 = n589;
      6'b001000: n596 = n585;
      6'b000100: n596 = n582;
      6'b000010: n596 = n579;
      6'b000001: n596 = n576;
      default: n596 = 8'b00000000;
    endcase
  /*# cupu_core.vhd:317:7 */
  assign n598 = n574 ? n596 : 8'b00000000;
  /*# cupu_core.vhd:331:7 */
  assign n602 = acc_size == 2'b00;
  /*# cupu_core.vhd:332:7 */
  assign n605 = acc_size == 2'b01;
  /*# cupu_core.vhd:330:5 */
  assign n606 = {n605, n602};
  assign n607 = n600[7:0]; // extract
  /*# cupu_core.vhd:330:5 */
  always @*
    case (n606)
      2'b10: n608 = n530;
      2'b01: n608 = n607;
      default: n608 = n530;
    endcase
  assign n609 = n600[23:8]; // extract
  /*# cupu_core.vhd:311:14 */
  assign n610 = {n598, n564};
  /*# cupu_core.vhd:330:5 */
  always @*
    case (n606)
      2'b10: n611 = 16'b0000000000000000;
      2'b01: n611 = n609;
      default: n611 = n610;
    endcase
  /*# cupu_core.vhd:311:14 */
  assign n612 = {n611, n608, n495};
  /*# cupu_core.vhd:338:50 */
  assign n615 = ~mmio_sel;
  /*# cupu_core.vhd:338:36 */
  assign n616 = n615 ? mem_rdata : mmio_rd;
  /*# cupu_core.vhd:341:30 */
  assign n619 = state == 5'b10010;
  /*# cupu_core.vhd:341:19 */
  assign n620 = n619 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:347:27 */
  assign n624 = state == 5'b00100;
  /*# cupu_core.vhd:347:42 */
  assign n626 = op == 5'b10011;
  /*# cupu_core.vhd:347:35 */
  assign n627 = n626 & n624;
  /*# cupu_core.vhd:347:66 */
  assign n629 = acc_addr == 32'b00100000000000000000000000000000;
  /*# cupu_core.vhd:347:53 */
  assign n630 = n629 & n627;
  /*# cupu_core.vhd:347:93 */
  assign n632 = acc_size == 2'b10;
  /*# cupu_core.vhd:347:80 */
  assign n633 = n632 & n630;
  /*# cupu_core.vhd:347:16 */
  assign n634 = n633 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:358:22 */
  assign n639 = {7'b0, prescale};  // uext
  /*# cupu_core.vhd:358:22 */
  assign n641 = n639 == 32'b00000001011111010111100000111111;
  /*# cupu_core.vhd:360:29 */
  assign n643 = seconds + 32'b00000000000000000000000000000001;
  /*# cupu_core.vhd:362:30 */
  assign n644 = {7'b0, prescale};  // uext
  /*# cupu_core.vhd:362:30 */
  assign n646 = n644 + 32'b00000000000000000000000000000001;
  /*# cupu_core.vhd:362:21 */
  assign n647 = n646[24:0];  // trunc
  /*# cupu_core.vhd:358:7 */
  assign n648 = n641 ? n643 : seconds;
  /*# cupu_core.vhd:358:7 */
  assign n650 = n641 ? 25'b0000000000000000000000000 : n647;
  /*# cupu_core.vhd:355:7 */
  assign n651 = ts_we ? opb : n648;
  /*# cupu_core.vhd:355:7 */
  assign n653 = ts_we ? 25'b0000000000000000000000000 : n650;
  /*# cupu_core.vhd:352:7 */
  assign n655 = rst ? 32'b00000000000000000000000000000000 : n651;
  /*# cupu_core.vhd:352:7 */
  assign n657 = rst ? 25'b0000000000000000000000000 : n653;
  /*# cupu_core.vhd:378:29 */
  assign n664 = kbd_sync[1:0]; // extract
  /*# cupu_core.vhd:378:50 */
  assign n665 = kbd_in[7]; // extract
  /*# cupu_core.vhd:378:42 */
  assign n666 = {n664, n665};
  /*# cupu_core.vhd:379:20 */
  assign n667 = kbd_sync[1]; // extract
  /*# cupu_core.vhd:379:42 */
  assign n668 = kbd_sync[2]; // extract
  /*# cupu_core.vhd:379:46 */
  assign n669 = ~n668;
  /*# cupu_core.vhd:379:30 */
  assign n670 = n669 & n667;
  /*# cupu_core.vhd:380:30 */
  assign n671 = kbd_in[6:0]; // extract
  /*# cupu_core.vhd:382:9 */
  assign n673 = kbd_take ? 1'b0 : kbd_valid;
  /*# cupu_core.vhd:379:9 */
  assign n674 = n670 ? n671 : kbd_data;
  /*# cupu_core.vhd:379:9 */
  assign n676 = n670 ? 1'b1 : n673;
  /*# cupu_core.vhd:373:7 */
  assign n678 = rst ? 3'b000 : n666;
  /*# cupu_core.vhd:373:7 */
  assign n680 = rst ? 7'b0000000 : n674;
  /*# cupu_core.vhd:373:7 */
  assign n682 = rst ? 1'b0 : n676;
  /*# cupu_core.vhd:395:16 */
  assign n691 = state == 5'b10001;
  /*# cupu_core.vhd:396:14 */
  assign n694 = 5'b11111 - cnt;
  /*# cupu_core.vhd:397:20 */
  assign n699 = state == 5'b00101;
  /*# cupu_core.vhd:397:36 */
  assign n701 = state == 5'b00110;
  /*# cupu_core.vhd:397:27 */
  assign n702 = n699 | n701;
  /*# cupu_core.vhd:397:53 */
  assign n704 = f_t != 5'b00000;
  /*# cupu_core.vhd:397:45 */
  assign n705 = n704 & n702;
  /*# cupu_core.vhd:398:14 */
  assign n708 = 5'b11111 - f_t;
  /*# cupu_core.vhd:397:7 */
  assign n711 = n705 ? n1435 : regs;
  /*# cupu_core.vhd:395:7 */
  assign n712 = n691 ? n1300 : n711;
  /*# cupu_core.vhd:419:23 */
  assign n721 = add_s[33]; // extract
  /*# cupu_core.vhd:420:31 */
  assign n722 = opa == opb;
  /*# cupu_core.vhd:420:22 */
  assign n724 = n722 ? 1'b1 : 1'b0;
  /*# cupu_core.vhd:421:30 */
  assign n727 = op == 5'b00110;
  /*# cupu_core.vhd:421:22 */
  assign n729 = n727 ? 1'b0 : 1'b1;
  /*# cupu_core.vhd:425:13 */
  assign n732 = acc_done ? 5'b00001 : state;
  /*# cupu_core.vhd:425:13 */
  assign n733 = acc_done ? acc_rdata : ir;
  /*# cupu_core.vhd:424:11 */
  assign n735 = state == 5'b00000;
  /*# cupu_core.vhd:430:11 */
  assign n737 = state == 5'b00001;
  /*# cupu_core.vhd:435:22 */
  assign n739 = f_opc == 5'b00000;
  /*# cupu_core.vhd:437:24 */
  assign n740 = f_opc[4:3]; // extract
  /*# cupu_core.vhd:437:37 */
  assign n742 = n740 == 2'b11;
  /*# cupu_core.vhd:438:31 */
  assign n743 = ir[15:0]; // extract
  /*# cupu_core.vhd:438:22 */
  assign n744 = {16'b0, n743};  // uext
  /*# cupu_core.vhd:440:47 */
  assign n745 = ir[15:0]; // extract
  /*# cupu_core.vhd:440:31 */
  assign n746 = {{16{n745[15]}}, n745}; // sext
  /*# cupu_core.vhd:437:13 */
  assign n747 = n742 ? n744 : n746;
  /*# cupu_core.vhd:435:13 */
  assign n748 = n739 ? rf_rd : n747;
  /*# cupu_core.vhd:434:11 */
  assign n750 = state == 5'b00010;
  /*# cupu_core.vhd:446:38 */
  assign n751 = ~flag;
  /*# cupu_core.vhd:446:29 */
  assign n752 = n751 & f_cond;
  /*# cupu_core.vhd:450:53 */
  assign n753 = add_s[31:0]; // extract
  /*# cupu_core.vhd:450:17 */
  assign n755 = op == 5'b00001;
  /*# cupu_core.vhd:450:29 */
  assign n757 = op == 5'b00010;
  /*# cupu_core.vhd:450:29 */
  assign n758 = n755 | n757;
  /*# cupu_core.vhd:451:44 */
  assign n759 = opa | opb;
  /*# cupu_core.vhd:451:17 */
  assign n761 = op == 5'b01000;
  /*# cupu_core.vhd:452:44 */
  assign n762 = opa & opb;
  /*# cupu_core.vhd:452:17 */
  assign n764 = op == 5'b01001;
  /*# cupu_core.vhd:453:44 */
  assign n765 = opa ^ opb;
  /*# cupu_core.vhd:453:17 */
  assign n767 = op == 5'b01010;
  /*# cupu_core.vhd:454:40 */
  assign n768 = ~opa;
  /*# cupu_core.vhd:454:17 */
  assign n770 = op == 5'b01011;
  /*# cupu_core.vhd:455:51 */
  assign n771 = add_s[32]; // extract
  /*# cupu_core.vhd:455:40 */
  assign n803 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, n771};
  /*# cupu_core.vhd:455:17 */
  assign n805 = op == 5'b01110;
  /*# cupu_core.vhd:456:47 */
  assign n806 = ~n721;
  /*# cupu_core.vhd:456:55 */
  assign n807 = n806 | n724;
  /*# cupu_core.vhd:456:40 */
  assign n839 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, n807};
  /*# cupu_core.vhd:456:17 */
  assign n841 = op == 5'b01111;
  /*# cupu_core.vhd:457:17 */
  assign n843 = op == 5'b10000;
  /*# cupu_core.vhd:460:43 */
  assign n844 = opb[15:0]; // extract
  /*# cupu_core.vhd:460:57 */
  assign n846 = {n844, 16'b0000000000000000};
  /*# cupu_core.vhd:460:17 */
  assign n848 = op == 5'b10101;
  /*# cupu_core.vhd:463:28 */
  assign n849 = f_fn[2:0]; // extract
  /*# cupu_core.vhd:464:21 */
  assign n851 = n849 == 3'b000;
  /*# cupu_core.vhd:465:44 */
  assign n852 = ~n724;
  /*# cupu_core.vhd:465:21 */
  assign n854 = n849 == 3'b001;
  /*# cupu_core.vhd:466:51 */
  assign n855 = ~n724;
  /*# cupu_core.vhd:466:47 */
  assign n856 = n721 & n855;
  /*# cupu_core.vhd:466:21 */
  assign n858 = n849 == 3'b010;
  /*# cupu_core.vhd:467:21 */
  assign n860 = n849 == 3'b011;
  /*# cupu_core.vhd:468:44 */
  assign n861 = ~n721;
  /*# cupu_core.vhd:468:21 */
  assign n863 = n849 == 3'b100;
  /*# cupu_core.vhd:469:45 */
  assign n864 = ~n721;
  /*# cupu_core.vhd:469:53 */
  assign n865 = n864 | n724;
  /*# cupu_core.vhd:463:19 */
  assign n866 = {n863, n860, n858, n854, n851};
  /*# cupu_core.vhd:463:19 */
  always @*
    case (n866)
      5'b10000: n867 = n861;
      5'b01000: n867 = n721;
      5'b00100: n867 = n856;
      5'b00010: n867 = n852;
      5'b00001: n867 = n724;
      default: n867 = n865;
    endcase
  /*# cupu_core.vhd:462:17 */
  assign n869 = op == 5'b10001;
  /*# cupu_core.vhd:473:17 */
  assign n871 = op == 5'b00011;
  /*# cupu_core.vhd:473:29 */
  assign n873 = op == 5'b00100;
  /*# cupu_core.vhd:473:29 */
  assign n874 = n871 | n873;
  /*# cupu_core.vhd:479:26 */
  assign n876 = opb == 32'b00000000000000000000000000000000;
  /*# cupu_core.vhd:479:19 */
  assign n879 = n876 ? 5'b10010 : 5'b01010;
  /*# cupu_core.vhd:478:17 */
  assign n881 = op == 5'b00101;
  /*# cupu_core.vhd:478:29 */
  assign n883 = op == 5'b00110;
  /*# cupu_core.vhd:478:29 */
  assign n884 = n881 | n883;
  /*# cupu_core.vhd:478:39 */
  assign n886 = op == 5'b00111;
  /*# cupu_core.vhd:478:39 */
  assign n887 = n884 | n886;
  /*# cupu_core.vhd:486:25 */
  assign n888 = opb[31:5]; // extract
  /*# cupu_core.vhd:486:39 */
  assign n890 = n888 != 27'b000000000000000000000000000;
  /*# cupu_core.vhd:490:33 */
  assign n891 = opb[4:0]; // extract
  /*# cupu_core.vhd:486:19 */
  assign n894 = n890 ? 5'b00101 : 5'b01111;
  /*# cupu_core.vhd:486:19 */
  assign n896 = n890 ? 32'b00000000000000000000000000000000 : opa;
  /*# cupu_core.vhd:486:19 */
  assign n897 = n890 ? cnt : n891;
  /*# cupu_core.vhd:485:17 */
  assign n899 = op == 5'b01100;
  /*# cupu_core.vhd:485:29 */
  assign n901 = op == 5'b01101;
  /*# cupu_core.vhd:485:29 */
  assign n902 = n899 | n901;
  /*# cupu_core.vhd:494:17 */
  assign n904 = op == 5'b10010;
  /*# cupu_core.vhd:494:30 */
  assign n906 = op == 5'b10011;
  /*# cupu_core.vhd:494:30 */
  assign n907 = n904 | n906;
  /*# cupu_core.vhd:499:33 */
  assign n908 = add_s[31:0]; // extract
  /*# cupu_core.vhd:497:17 */
  assign n910 = op == 5'b10110;
  /*# cupu_core.vhd:503:33 */
  assign n911 = add_s[31:0]; // extract
  /*# cupu_core.vhd:502:17 */
  assign n913 = op == 5'b10111;
  /*# cupu_core.vhd:506:17 */
  assign n915 = op == 5'b10100;
  /*# cupu_core.vhd:509:17 */
  assign n917 = op == 5'b00000;
  /*# cupu_core.vhd:449:15 */
  assign n918 = {n917, n915, n913, n910, n907, n902, n887, n874, n869, n848, n843, n841, n805, n770, n767, n764, n761, n758};
  /*# cupu_core.vhd:449:15 */
  always @*
    case (n918)
      18'b100000000000000000: n929 = 5'b00111;
      18'b010000000000000000: n929 = 5'b10010;
      18'b001000000000000000: n929 = 5'b01000;
      18'b000100000000000000: n929 = 5'b00110;
      18'b000010000000000000: n929 = 5'b00100;
      18'b000001000000000000: n929 = n894;
      18'b000000100000000000: n929 = n879;
      18'b000000010000000000: n929 = 5'b01001;
      18'b000000001000000000: n929 = 5'b00111;
      18'b000000000100000000: n929 = 5'b00101;
      18'b000000000010000000: n929 = 5'b10000;
      18'b000000000001000000: n929 = 5'b00101;
      18'b000000000000100000: n929 = 5'b00101;
      18'b000000000000010000: n929 = 5'b00101;
      18'b000000000000001000: n929 = 5'b00101;
      18'b000000000000000100: n929 = 5'b00101;
      18'b000000000000000010: n929 = 5'b00101;
      18'b000000000000000001: n929 = 5'b00101;
      default: n929 = 5'bX;
    endcase
  /*# cupu_core.vhd:449:15 */
  always @*
    case (n918)
      18'b100000000000000000: n931 = pc;
      18'b010000000000000000: n931 = pc;
      18'b001000000000000000: n931 = pc;
      18'b000100000000000000: n931 = n908;
      18'b000010000000000000: n931 = pc;
      18'b000001000000000000: n931 = pc;
      18'b000000100000000000: n931 = pc;
      18'b000000010000000000: n931 = pc;
      18'b000000001000000000: n931 = pc;
      18'b000000000100000000: n931 = pc;
      18'b000000000010000000: n931 = pc;
      18'b000000000001000000: n931 = pc;
      18'b000000000000100000: n931 = pc;
      18'b000000000000010000: n931 = pc;
      18'b000000000000001000: n931 = pc;
      18'b000000000000000100: n931 = pc;
      18'b000000000000000010: n931 = pc;
      18'b000000000000000001: n931 = pc;
      default: n931 = 32'bX;
    endcase
  /*# cupu_core.vhd:449:15 */
  always @*
    case (n918)
      18'b100000000000000000: n933 = opa;
      18'b010000000000000000: n933 = opa;
      18'b001000000000000000: n933 = n911;
      18'b000100000000000000: n933 = opa;
      18'b000010000000000000: n933 = opa;
      18'b000001000000000000: n933 = opa;
      18'b000000100000000000: n933 = opa;
      18'b000000010000000000: n933 = opa;
      18'b000000001000000000: n933 = opa;
      18'b000000000100000000: n933 = opa;
      18'b000000000010000000: n933 = opa;
      18'b000000000001000000: n933 = opa;
      18'b000000000000100000: n933 = opa;
      18'b000000000000010000: n933 = opa;
      18'b000000000000001000: n933 = opa;
      18'b000000000000000100: n933 = opa;
      18'b000000000000000010: n933 = opa;
      18'b000000000000000001: n933 = opa;
      default: n933 = 32'bX;
    endcase
  /*# cupu_core.vhd:449:15 */
  always @*
    case (n918)
      18'b100000000000000000: n936 = acc;
      18'b010000000000000000: n936 = acc;
      18'b001000000000000000: n936 = acc;
      18'b000100000000000000: n936 = pc_inc;
      18'b000010000000000000: n936 = acc;
      18'b000001000000000000: n936 = n896;
      18'b000000100000000000: n936 = acc;
      18'b000000010000000000: n936 = 32'b00000000000000000000000000000000;
      18'b000000001000000000: n936 = acc;
      18'b000000000100000000: n936 = n846;
      18'b000000000010000000: n936 = acc;
      18'b000000000001000000: n936 = n839;
      18'b000000000000100000: n936 = n803;
      18'b000000000000010000: n936 = n768;
      18'b000000000000001000: n936 = n765;
      18'b000000000000000100: n936 = n762;
      18'b000000000000000010: n936 = n759;
      18'b000000000000000001: n936 = n753;
      default: n936 = 32'bX;
    endcase
  /*# cupu_core.vhd:449:15 */
  always @*
    case (n918)
      18'b100000000000000000: n939 = cnt;
      18'b010000000000000000: n939 = cnt;
      18'b001000000000000000: n939 = cnt;
      18'b000100000000000000: n939 = cnt;
      18'b000010000000000000: n939 = cnt;
      18'b000001000000000000: n939 = n897;
      18'b000000100000000000: n939 = cnt;
      18'b000000010000000000: n939 = 5'b00000;
      18'b000000001000000000: n939 = cnt;
      18'b000000000100000000: n939 = cnt;
      18'b000000000010000000: n939 = cnt;
      18'b000000000001000000: n939 = cnt;
      18'b000000000000100000: n939 = cnt;
      18'b000000000000010000: n939 = cnt;
      18'b000000000000001000: n939 = cnt;
      18'b000000000000000100: n939 = cnt;
      18'b000000000000000010: n939 = cnt;
      18'b000000000000000001: n939 = cnt;
      default: n939 = 5'bX;
    endcase
  /*# cupu_core.vhd:449:15 */
  always @*
    case (n918)
      18'b100000000000000000: n941 = flag;
      18'b010000000000000000: n941 = flag;
      18'b001000000000000000: n941 = flag;
      18'b000100000000000000: n941 = flag;
      18'b000010000000000000: n941 = flag;
      18'b000001000000000000: n941 = flag;
      18'b000000100000000000: n941 = flag;
      18'b000000010000000000: n941 = flag;
      18'b000000001000000000: n941 = n867;
      18'b000000000100000000: n941 = flag;
      18'b000000000010000000: n941 = flag;
      18'b000000000001000000: n941 = flag;
      18'b000000000000100000: n941 = flag;
      18'b000000000000010000: n941 = flag;
      18'b000000000000001000: n941 = flag;
      18'b000000000000000100: n941 = flag;
      18'b000000000000000010: n941 = flag;
      18'b000000000000000001: n941 = flag;
      default: n941 = 1'bX;
    endcase
  /*# cupu_core.vhd:449:15 */
  always @*
    case (n918)
      18'b100000000000000000: n945 = 1'b0;
      18'b010000000000000000: n945 = 1'b0;
      18'b001000000000000000: n945 = 1'b0;
      18'b000100000000000000: n945 = 1'b0;
      18'b000010000000000000: n945 = 1'b0;
      18'b000001000000000000: n945 = 1'b0;
      18'b000000100000000000: n945 = 1'b0;
      18'b000000010000000000: n945 = 1'b0;
      18'b000000001000000000: n945 = 1'b0;
      18'b000000000100000000: n945 = 1'b0;
      18'b000000000010000000: n945 = 1'b1;
      18'b000000000001000000: n945 = 1'b0;
      18'b000000000000100000: n945 = 1'b0;
      18'b000000000000010000: n945 = 1'b0;
      18'b000000000000001000: n945 = 1'b0;
      18'b000000000000000100: n945 = 1'b0;
      18'b000000000000000010: n945 = 1'b0;
      18'b000000000000000001: n945 = 1'b0;
      default: n945 = 1'bX;
    endcase
  /*# cupu_core.vhd:446:13 */
  assign n947 = n752 ? 5'b00111 : n929;
  /*# cupu_core.vhd:446:13 */
  assign n949 = n752 ? pc : n931;
  /*# cupu_core.vhd:446:13 */
  assign n950 = n752 ? opa : n933;
  /*# cupu_core.vhd:446:13 */
  assign n951 = n752 ? acc : n936;
  /*# cupu_core.vhd:446:13 */
  assign n952 = n752 ? cnt : n939;
  /*# cupu_core.vhd:446:13 */
  assign n953 = n752 ? flag : n941;
  /*# cupu_core.vhd:446:13 */
  assign n955 = n752 ? 1'b0 : n945;
  /*# cupu_core.vhd:444:11 */
  assign n957 = state == 5'b00011;
  /*# cupu_core.vhd:516:27 */
  assign n958 = add_s[31:0]; // extract
  /*# cupu_core.vhd:514:11 */
  assign n960 = state == 5'b01000;
  /*# cupu_core.vhd:520:25 */
  assign n961 = add_s[32:1]; // extract
  /*# cupu_core.vhd:521:25 */
  assign n962 = add_s[0]; // extract
  /*# cupu_core.vhd:521:34 */
  assign n963 = opa[31:1]; // extract
  /*# cupu_core.vhd:521:29 */
  assign n964 = {n962, n963};
  /*# cupu_core.vhd:522:24 */
  assign n966 = cnt + 5'b00001;
  /*# cupu_core.vhd:523:20 */
  assign n968 = cnt == 5'b11111;
  /*# cupu_core.vhd:523:13 */
  assign n970 = n968 ? 5'b00101 : state;
  /*# cupu_core.vhd:519:11 */
  assign n972 = state == 5'b01001;
  /*# cupu_core.vhd:528:36 */
  assign n973 = opa[31]; // extract
  /*# cupu_core.vhd:528:48 */
  assign n974 = opb[31]; // extract
  /*# cupu_core.vhd:528:41 */
  assign n975 = n973 ^ n974;
  /*# cupu_core.vhd:528:28 */
  assign n976 = n729 & n975;
  /*# cupu_core.vhd:529:35 */
  assign n977 = opa[31]; // extract
  /*# cupu_core.vhd:529:28 */
  assign n978 = n729 & n977;
  /*# cupu_core.vhd:530:35 */
  assign n979 = opa[31]; // extract
  /*# cupu_core.vhd:530:28 */
  assign n980 = n979 & n729;
  /*# cupu_core.vhd:531:27 */
  assign n981 = add_s[31:0]; // extract
  /*# cupu_core.vhd:530:13 */
  assign n982 = n980 ? n981 : opa;
  /*# cupu_core.vhd:527:11 */
  assign n984 = state == 5'b01010;
  /*# cupu_core.vhd:536:35 */
  assign n985 = opb[31]; // extract
  /*# cupu_core.vhd:536:28 */
  assign n986 = n985 & n729;
  /*# cupu_core.vhd:537:27 */
  assign n987 = add_s[31:0]; // extract
  /*# cupu_core.vhd:536:13 */
  assign n988 = n986 ? n987 : opb;
  /*# cupu_core.vhd:535:11 */
  assign n990 = state == 5'b01011;
  /*# cupu_core.vhd:546:27 */
  assign n991 = add_s[31:0]; // extract
  /*# cupu_core.vhd:548:25 */
  assign n992 = acc[30:0]; // extract
  /*# cupu_core.vhd:548:44 */
  assign n993 = opa[31]; // extract
  /*# cupu_core.vhd:548:39 */
  assign n994 = {n992, n993};
  /*# cupu_core.vhd:545:13 */
  assign n995 = n721 ? n991 : n994;
  /*# cupu_core.vhd:550:23 */
  assign n996 = opa[30:0]; // extract
  /*# cupu_core.vhd:550:37 */
  assign n997 = {n996, n721};
  /*# cupu_core.vhd:551:24 */
  assign n999 = cnt + 5'b00001;
  /*# cupu_core.vhd:552:20 */
  assign n1001 = cnt == 5'b11111;
  /*# cupu_core.vhd:552:13 */
  assign n1003 = n1001 ? 5'b01101 : state;
  /*# cupu_core.vhd:543:11 */
  assign n1005 = state == 5'b01100;
  /*# cupu_core.vhd:558:27 */
  assign n1006 = add_s[31:0]; // extract
  /*# cupu_core.vhd:557:13 */
  assign n1007 = sgn_q ? n1006 : opa;
  /*# cupu_core.vhd:556:11 */
  assign n1009 = state == 5'b01101;
  /*# cupu_core.vhd:564:27 */
  assign n1010 = add_s[31:0]; // extract
  /*# cupu_core.vhd:563:13 */
  assign n1011 = sgn_r ? n1010 : acc;
  /*# cupu_core.vhd:562:11 */
  assign n1013 = state == 5'b01110;
  /*# cupu_core.vhd:569:20 */
  assign n1015 = cnt == 5'b00000;
  /*# cupu_core.vhd:572:22 */
  assign n1016 = f_fn[0]; // extract
  /*# cupu_core.vhd:572:26 */
  assign n1017 = ~n1016;
  /*# cupu_core.vhd:573:27 */
  assign n1018 = acc[30:0]; // extract
  /*# cupu_core.vhd:573:41 */
  assign n1020 = {n1018, 1'b0};
  /*# cupu_core.vhd:575:33 */
  assign n1021 = acc[31:1]; // extract
  /*# cupu_core.vhd:575:28 */
  assign n1023 = {1'b0, n1021};
  /*# cupu_core.vhd:572:15 */
  assign n1024 = n1017 ? n1020 : n1023;
  /*# cupu_core.vhd:577:26 */
  assign n1026 = cnt - 5'b00001;
  /*# cupu_core.vhd:569:13 */
  assign n1028 = n1015 ? 5'b00101 : state;
  /*# cupu_core.vhd:569:13 */
  assign n1029 = n1015 ? acc : n1024;
  /*# cupu_core.vhd:569:13 */
  assign n1030 = n1015 ? cnt : n1026;
  /*# cupu_core.vhd:568:11 */
  assign n1032 = state == 5'b01111;
  /*# cupu_core.vhd:582:21 */
  assign n1034 = op == 5'b10010;
  /*# cupu_core.vhd:586:43 */
  assign n1036 = opa == 32'b00100000000000000000000000001000;
  /*# cupu_core.vhd:586:35 */
  assign n1037 = n1036 & mmio_sel;
  /*# cupu_core.vhd:587:47 */
  assign n1038 = opb[7:0]; // extract
  /*# cupu_core.vhd:586:17 */
  assign n1039 = n1037 ? n1038 : gpio;
  /*# cupu_core.vhd:582:15 */
  assign n1042 = n1034 ? 5'b00101 : 5'b00111;
  /*# cupu_core.vhd:581:13 */
  assign n1043 = n1046 ? acc_rdata : acc;
  /*# cupu_core.vhd:582:15 */
  assign n1044 = n1034 ? gpio : n1039;
  /*# cupu_core.vhd:581:13 */
  assign n1045 = acc_done ? n1042 : state;
  /*# cupu_core.vhd:581:13 */
  assign n1046 = n1034 & acc_done;
  /*# cupu_core.vhd:581:13 */
  assign n1047 = acc_done ? n1044 : gpio;
  /*# cupu_core.vhd:580:11 */
  assign n1049 = state == 5'b00100;
  /*# cupu_core.vhd:593:11 */
  assign n1051 = state == 5'b00101;
  /*# cupu_core.vhd:593:21 */
  assign n1053 = state == 5'b00111;
  /*# cupu_core.vhd:593:21 */
  assign n1054 = n1051 | n1053;
  /*# cupu_core.vhd:597:11 */
  assign n1056 = state == 5'b00110;
  /*# cupu_core.vhd:601:13 */
  assign n1058 = fpu_done ? 5'b00101 : state;
  /*# cupu_core.vhd:601:13 */
  assign n1059 = fpu_done ? fpu_res : acc;
  /*# cupu_core.vhd:600:11 */
  assign n1061 = state == 5'b10000;
  /*# cupu_core.vhd:607:24 */
  assign n1063 = cnt + 5'b00001;
  /*# cupu_core.vhd:608:20 */
  assign n1065 = cnt == 5'b11111;
  /*# cupu_core.vhd:608:13 */
  assign n1067 = n1065 ? 5'b00000 : state;
  /*# cupu_core.vhd:606:11 */
  assign n1069 = state == 5'b10001;
  /*# cupu_core.vhd:612:11 */
  assign n1071 = state == 5'b10010;
  /*# cupu_core.vhd:423:9 */
  assign n1072 = {n1071, n1069, n1061, n1056, n1054, n1049, n1032, n1013, n1009, n1005, n990, n984, n972, n960, n957, n750, n737, n735};
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1083 = state;
      18'b010000000000000000: n1083 = n1067;
      18'b001000000000000000: n1083 = n1058;
      18'b000100000000000000: n1083 = 5'b00000;
      18'b000010000000000000: n1083 = 5'b00000;
      18'b000001000000000000: n1083 = n1045;
      18'b000000100000000000: n1083 = n1028;
      18'b000000010000000000: n1083 = 5'b00101;
      18'b000000001000000000: n1083 = 5'b01110;
      18'b000000000100000000: n1083 = n1003;
      18'b000000000010000000: n1083 = 5'b01100;
      18'b000000000001000000: n1083 = 5'b01011;
      18'b000000000000100000: n1083 = n970;
      18'b000000000000010000: n1083 = 5'b00110;
      18'b000000000000001000: n1083 = n947;
      18'b000000000000000100: n1083 = 5'b00011;
      18'b000000000000000010: n1083 = 5'b00010;
      18'b000000000000000001: n1083 = n732;
      default: n1083 = 5'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1085 = pc;
      18'b010000000000000000: n1085 = pc;
      18'b001000000000000000: n1085 = pc;
      18'b000100000000000000: n1085 = pc;
      18'b000010000000000000: n1085 = pc_inc;
      18'b000001000000000000: n1085 = pc;
      18'b000000100000000000: n1085 = pc;
      18'b000000010000000000: n1085 = pc;
      18'b000000001000000000: n1085 = pc;
      18'b000000000100000000: n1085 = pc;
      18'b000000000010000000: n1085 = pc;
      18'b000000000001000000: n1085 = pc;
      18'b000000000000100000: n1085 = pc;
      18'b000000000000010000: n1085 = n958;
      18'b000000000000001000: n1085 = n949;
      18'b000000000000000100: n1085 = pc;
      18'b000000000000000010: n1085 = pc;
      18'b000000000000000001: n1085 = pc;
      default: n1085 = 32'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1087 = ir;
      18'b010000000000000000: n1087 = ir;
      18'b001000000000000000: n1087 = ir;
      18'b000100000000000000: n1087 = ir;
      18'b000010000000000000: n1087 = ir;
      18'b000001000000000000: n1087 = ir;
      18'b000000100000000000: n1087 = ir;
      18'b000000010000000000: n1087 = ir;
      18'b000000001000000000: n1087 = ir;
      18'b000000000100000000: n1087 = ir;
      18'b000000000010000000: n1087 = ir;
      18'b000000000001000000: n1087 = ir;
      18'b000000000000100000: n1087 = ir;
      18'b000000000000010000: n1087 = ir;
      18'b000000000000001000: n1087 = ir;
      18'b000000000000000100: n1087 = ir;
      18'b000000000000000010: n1087 = ir;
      18'b000000000000000001: n1087 = n733;
      default: n1087 = 32'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1089 = opa;
      18'b010000000000000000: n1089 = opa;
      18'b001000000000000000: n1089 = opa;
      18'b000100000000000000: n1089 = opa;
      18'b000010000000000000: n1089 = opa;
      18'b000001000000000000: n1089 = opa;
      18'b000000100000000000: n1089 = opa;
      18'b000000010000000000: n1089 = opa;
      18'b000000001000000000: n1089 = n1007;
      18'b000000000100000000: n1089 = n997;
      18'b000000000010000000: n1089 = opa;
      18'b000000000001000000: n1089 = n982;
      18'b000000000000100000: n1089 = n964;
      18'b000000000000010000: n1089 = opa;
      18'b000000000000001000: n1089 = n950;
      18'b000000000000000100: n1089 = opa;
      18'b000000000000000010: n1089 = rf_rd;
      18'b000000000000000001: n1089 = opa;
      default: n1089 = 32'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1091 = opb;
      18'b010000000000000000: n1091 = opb;
      18'b001000000000000000: n1091 = opb;
      18'b000100000000000000: n1091 = opb;
      18'b000010000000000000: n1091 = opb;
      18'b000001000000000000: n1091 = opb;
      18'b000000100000000000: n1091 = opb;
      18'b000000010000000000: n1091 = opb;
      18'b000000001000000000: n1091 = opb;
      18'b000000000100000000: n1091 = opb;
      18'b000000000010000000: n1091 = n988;
      18'b000000000001000000: n1091 = opb;
      18'b000000000000100000: n1091 = opb;
      18'b000000000000010000: n1091 = opb;
      18'b000000000000001000: n1091 = opb;
      18'b000000000000000100: n1091 = n748;
      18'b000000000000000010: n1091 = opb;
      18'b000000000000000001: n1091 = opb;
      default: n1091 = 32'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1094 = acc;
      18'b010000000000000000: n1094 = acc;
      18'b001000000000000000: n1094 = n1059;
      18'b000100000000000000: n1094 = acc;
      18'b000010000000000000: n1094 = acc;
      18'b000001000000000000: n1094 = n1043;
      18'b000000100000000000: n1094 = n1029;
      18'b000000010000000000: n1094 = n1011;
      18'b000000001000000000: n1094 = acc;
      18'b000000000100000000: n1094 = n995;
      18'b000000000010000000: n1094 = 32'b00000000000000000000000000000000;
      18'b000000000001000000: n1094 = acc;
      18'b000000000000100000: n1094 = n961;
      18'b000000000000010000: n1094 = pc_inc;
      18'b000000000000001000: n1094 = n951;
      18'b000000000000000100: n1094 = acc;
      18'b000000000000000010: n1094 = acc;
      18'b000000000000000001: n1094 = acc;
      default: n1094 = 32'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1097 = cnt;
      18'b010000000000000000: n1097 = n1063;
      18'b001000000000000000: n1097 = cnt;
      18'b000100000000000000: n1097 = cnt;
      18'b000010000000000000: n1097 = cnt;
      18'b000001000000000000: n1097 = cnt;
      18'b000000100000000000: n1097 = n1030;
      18'b000000010000000000: n1097 = cnt;
      18'b000000001000000000: n1097 = cnt;
      18'b000000000100000000: n1097 = n999;
      18'b000000000010000000: n1097 = 5'b00000;
      18'b000000000001000000: n1097 = cnt;
      18'b000000000000100000: n1097 = n966;
      18'b000000000000010000: n1097 = cnt;
      18'b000000000000001000: n1097 = n952;
      18'b000000000000000100: n1097 = cnt;
      18'b000000000000000010: n1097 = cnt;
      18'b000000000000000001: n1097 = cnt;
      default: n1097 = 5'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1099 = flag;
      18'b010000000000000000: n1099 = flag;
      18'b001000000000000000: n1099 = flag;
      18'b000100000000000000: n1099 = flag;
      18'b000010000000000000: n1099 = flag;
      18'b000001000000000000: n1099 = flag;
      18'b000000100000000000: n1099 = flag;
      18'b000000010000000000: n1099 = flag;
      18'b000000001000000000: n1099 = flag;
      18'b000000000100000000: n1099 = flag;
      18'b000000000010000000: n1099 = flag;
      18'b000000000001000000: n1099 = flag;
      18'b000000000000100000: n1099 = flag;
      18'b000000000000010000: n1099 = flag;
      18'b000000000000001000: n1099 = n953;
      18'b000000000000000100: n1099 = flag;
      18'b000000000000000010: n1099 = flag;
      18'b000000000000000001: n1099 = flag;
      default: n1099 = 1'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1101 = sgn_q;
      18'b010000000000000000: n1101 = sgn_q;
      18'b001000000000000000: n1101 = sgn_q;
      18'b000100000000000000: n1101 = sgn_q;
      18'b000010000000000000: n1101 = sgn_q;
      18'b000001000000000000: n1101 = sgn_q;
      18'b000000100000000000: n1101 = sgn_q;
      18'b000000010000000000: n1101 = sgn_q;
      18'b000000001000000000: n1101 = sgn_q;
      18'b000000000100000000: n1101 = sgn_q;
      18'b000000000010000000: n1101 = sgn_q;
      18'b000000000001000000: n1101 = n976;
      18'b000000000000100000: n1101 = sgn_q;
      18'b000000000000010000: n1101 = sgn_q;
      18'b000000000000001000: n1101 = sgn_q;
      18'b000000000000000100: n1101 = sgn_q;
      18'b000000000000000010: n1101 = sgn_q;
      18'b000000000000000001: n1101 = sgn_q;
      default: n1101 = 1'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1103 = sgn_r;
      18'b010000000000000000: n1103 = sgn_r;
      18'b001000000000000000: n1103 = sgn_r;
      18'b000100000000000000: n1103 = sgn_r;
      18'b000010000000000000: n1103 = sgn_r;
      18'b000001000000000000: n1103 = sgn_r;
      18'b000000100000000000: n1103 = sgn_r;
      18'b000000010000000000: n1103 = sgn_r;
      18'b000000001000000000: n1103 = sgn_r;
      18'b000000000100000000: n1103 = sgn_r;
      18'b000000000010000000: n1103 = sgn_r;
      18'b000000000001000000: n1103 = n978;
      18'b000000000000100000: n1103 = sgn_r;
      18'b000000000000010000: n1103 = sgn_r;
      18'b000000000000001000: n1103 = sgn_r;
      18'b000000000000000100: n1103 = sgn_r;
      18'b000000000000000010: n1103 = sgn_r;
      18'b000000000000000001: n1103 = sgn_r;
      default: n1103 = 1'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1106 = 1'b0;
      18'b010000000000000000: n1106 = 1'b0;
      18'b001000000000000000: n1106 = 1'b0;
      18'b000100000000000000: n1106 = 1'b0;
      18'b000010000000000000: n1106 = 1'b0;
      18'b000001000000000000: n1106 = 1'b0;
      18'b000000100000000000: n1106 = 1'b0;
      18'b000000010000000000: n1106 = 1'b0;
      18'b000000001000000000: n1106 = 1'b0;
      18'b000000000100000000: n1106 = 1'b0;
      18'b000000000010000000: n1106 = 1'b0;
      18'b000000000001000000: n1106 = 1'b0;
      18'b000000000000100000: n1106 = 1'b0;
      18'b000000000000010000: n1106 = 1'b0;
      18'b000000000000001000: n1106 = n955;
      18'b000000000000000100: n1106 = 1'b0;
      18'b000000000000000010: n1106 = 1'b0;
      18'b000000000000000001: n1106 = 1'b0;
      default: n1106 = 1'bX;
    endcase
  /*# cupu_core.vhd:423:9 */
  always @*
    case (n1072)
      18'b100000000000000000: n1108 = gpio;
      18'b010000000000000000: n1108 = gpio;
      18'b001000000000000000: n1108 = gpio;
      18'b000100000000000000: n1108 = gpio;
      18'b000010000000000000: n1108 = gpio;
      18'b000001000000000000: n1108 = n1047;
      18'b000000100000000000: n1108 = gpio;
      18'b000000010000000000: n1108 = gpio;
      18'b000000001000000000: n1108 = gpio;
      18'b000000000100000000: n1108 = gpio;
      18'b000000000010000000: n1108 = gpio;
      18'b000000000001000000: n1108 = gpio;
      18'b000000000000100000: n1108 = gpio;
      18'b000000000000010000: n1108 = gpio;
      18'b000000000000001000: n1108 = gpio;
      18'b000000000000000100: n1108 = gpio;
      18'b000000000000000010: n1108 = gpio;
      18'b000000000000000001: n1108 = gpio;
      default: n1108 = 8'bX;
    endcase
  /*# cupu_core.vhd:412:7 */
  assign n1110 = rst ? 5'b10001 : n1083;
  /*# cupu_core.vhd:412:7 */
  assign n1112 = rst ? 32'b00000000000000000000000000000000 : n1085;
  /*# cupu_core.vhd:412:7 */
  assign n1113 = rst ? ir : n1087;
  /*# cupu_core.vhd:412:7 */
  assign n1114 = rst ? opa : n1089;
  /*# cupu_core.vhd:412:7 */
  assign n1115 = rst ? opb : n1091;
  /*# cupu_core.vhd:412:7 */
  assign n1116 = rst ? acc : n1094;
  /*# cupu_core.vhd:412:7 */
  assign n1118 = rst ? 5'b00000 : n1097;
  /*# cupu_core.vhd:412:7 */
  assign n1120 = rst ? 1'b0 : n1099;
  /*# cupu_core.vhd:412:7 */
  assign n1121 = rst ? sgn_q : n1101;
  /*# cupu_core.vhd:412:7 */
  assign n1122 = rst ? sgn_r : n1103;
  /*# cupu_core.vhd:412:7 */
  assign n1124 = rst ? 1'b0 : n1106;
  /*# cupu_core.vhd:412:7 */
  assign n1127 = rst ? 8'b00000000 : n1108;
  /*# cupu_core.vhd:394:5 */
  always @(posedge clk)
    n1147 <= n712;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1148 <= n1110;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1149 <= n1112;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1150 <= n1113;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1151 <= n1114;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1152 <= n1115;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1153 <= n1116;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1154 <= n1118;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1155 <= n1120;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1156 <= n1121;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1157 <= n1122;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1158 <= n1124;
  /*# cupu_core.vhd:410:5 */
  always @(posedge clk)
    n1159 <= n1127;
  /*# cupu_core.vhd:351:5 */
  always @(posedge clk)
    n1160 <= n655;
  /*# cupu_core.vhd:372:5 */
  always @(posedge clk)
    n1161 <= n678;
  /*# cupu_core.vhd:372:5 */
  always @(posedge clk)
    n1162 <= n680;
  /*# cupu_core.vhd:372:5 */
  always @(posedge clk)
    n1163 <= n682;
  /*# cupu_core.vhd:351:5 */
  always @(posedge clk)
    n1164 <= n657;
  /*# cupu_core.vhd:167:21 */
  assign n1165 = regs[n187 * 32 +: 32]; //(Bmux)
  /*# cupu_core.vhd:396:9 */
  assign n1166 = n694[4]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1167 = ~n1166;
  /*# cupu_core.vhd:396:9 */
  assign n1168 = n694[3]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1169 = ~n1168;
  /*# cupu_core.vhd:396:9 */
  assign n1170 = n1167 & n1169;
  /*# cupu_core.vhd:396:9 */
  assign n1171 = n1167 & n1168;
  /*# cupu_core.vhd:396:9 */
  assign n1172 = n1166 & n1169;
  /*# cupu_core.vhd:396:9 */
  assign n1173 = n1166 & n1168;
  /*# cupu_core.vhd:396:9 */
  assign n1174 = n694[2]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1175 = ~n1174;
  /*# cupu_core.vhd:396:9 */
  assign n1176 = n1170 & n1175;
  /*# cupu_core.vhd:396:9 */
  assign n1177 = n1170 & n1174;
  /*# cupu_core.vhd:396:9 */
  assign n1178 = n1171 & n1175;
  /*# cupu_core.vhd:396:9 */
  assign n1179 = n1171 & n1174;
  /*# cupu_core.vhd:396:9 */
  assign n1180 = n1172 & n1175;
  /*# cupu_core.vhd:396:9 */
  assign n1181 = n1172 & n1174;
  /*# cupu_core.vhd:396:9 */
  assign n1182 = n1173 & n1175;
  /*# cupu_core.vhd:396:9 */
  assign n1183 = n1173 & n1174;
  /*# cupu_core.vhd:396:9 */
  assign n1184 = n694[1]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1185 = ~n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1186 = n1176 & n1185;
  /*# cupu_core.vhd:396:9 */
  assign n1187 = n1176 & n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1188 = n1177 & n1185;
  /*# cupu_core.vhd:396:9 */
  assign n1189 = n1177 & n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1190 = n1178 & n1185;
  /*# cupu_core.vhd:396:9 */
  assign n1191 = n1178 & n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1192 = n1179 & n1185;
  /*# cupu_core.vhd:396:9 */
  assign n1193 = n1179 & n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1194 = n1180 & n1185;
  /*# cupu_core.vhd:396:9 */
  assign n1195 = n1180 & n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1196 = n1181 & n1185;
  /*# cupu_core.vhd:396:9 */
  assign n1197 = n1181 & n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1198 = n1182 & n1185;
  /*# cupu_core.vhd:396:9 */
  assign n1199 = n1182 & n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1200 = n1183 & n1185;
  /*# cupu_core.vhd:396:9 */
  assign n1201 = n1183 & n1184;
  /*# cupu_core.vhd:396:9 */
  assign n1202 = n694[0]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1203 = ~n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1204 = n1186 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1205 = n1186 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1206 = n1187 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1207 = n1187 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1208 = n1188 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1209 = n1188 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1210 = n1189 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1211 = n1189 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1212 = n1190 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1213 = n1190 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1214 = n1191 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1215 = n1191 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1216 = n1192 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1217 = n1192 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1218 = n1193 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1219 = n1193 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1220 = n1194 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1221 = n1194 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1222 = n1195 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1223 = n1195 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1224 = n1196 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1225 = n1196 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1226 = n1197 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1227 = n1197 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1228 = n1198 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1229 = n1198 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1230 = n1199 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1231 = n1199 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1232 = n1200 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1233 = n1200 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1234 = n1201 & n1203;
  /*# cupu_core.vhd:396:9 */
  assign n1235 = n1201 & n1202;
  /*# cupu_core.vhd:396:9 */
  assign n1236 = regs[31:0]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1237 = n1204 ? 32'b00000000000000000000000000000000 : n1236;
  /*# cupu_core.vhd:396:9 */
  assign n1238 = regs[63:32]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1239 = n1205 ? 32'b00000000000000000000000000000000 : n1238;
  /*# cupu_core.vhd:396:9 */
  assign n1240 = regs[95:64]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1241 = n1206 ? 32'b00000000000000000000000000000000 : n1240;
  /*# cupu_core.vhd:396:9 */
  assign n1242 = regs[127:96]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1243 = n1207 ? 32'b00000000000000000000000000000000 : n1242;
  /*# cupu_core.vhd:396:9 */
  assign n1244 = regs[159:128]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1245 = n1208 ? 32'b00000000000000000000000000000000 : n1244;
  /*# cupu_core.vhd:396:9 */
  assign n1246 = regs[191:160]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1247 = n1209 ? 32'b00000000000000000000000000000000 : n1246;
  /*# cupu_core.vhd:396:9 */
  assign n1248 = regs[223:192]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1249 = n1210 ? 32'b00000000000000000000000000000000 : n1248;
  /*# cupu_core.vhd:396:9 */
  assign n1250 = regs[255:224]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1251 = n1211 ? 32'b00000000000000000000000000000000 : n1250;
  /*# cupu_core.vhd:396:9 */
  assign n1252 = regs[287:256]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1253 = n1212 ? 32'b00000000000000000000000000000000 : n1252;
  /*# cupu_core.vhd:396:9 */
  assign n1254 = regs[319:288]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1255 = n1213 ? 32'b00000000000000000000000000000000 : n1254;
  /*# cupu_core.vhd:396:9 */
  assign n1256 = regs[351:320]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1257 = n1214 ? 32'b00000000000000000000000000000000 : n1256;
  /*# cupu_core.vhd:396:9 */
  assign n1258 = regs[383:352]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1259 = n1215 ? 32'b00000000000000000000000000000000 : n1258;
  /*# cupu_core.vhd:396:9 */
  assign n1260 = regs[415:384]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1261 = n1216 ? 32'b00000000000000000000000000000000 : n1260;
  /*# cupu_core.vhd:396:9 */
  assign n1262 = regs[447:416]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1263 = n1217 ? 32'b00000000000000000000000000000000 : n1262;
  /*# cupu_core.vhd:396:9 */
  assign n1264 = regs[479:448]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1265 = n1218 ? 32'b00000000000000000000000000000000 : n1264;
  /*# cupu_core.vhd:396:9 */
  assign n1266 = regs[511:480]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1267 = n1219 ? 32'b00000000000000000000000000000000 : n1266;
  /*# cupu_core.vhd:396:9 */
  assign n1268 = regs[543:512]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1269 = n1220 ? 32'b00000000000000000000000000000000 : n1268;
  /*# cupu_core.vhd:396:9 */
  assign n1270 = regs[575:544]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1271 = n1221 ? 32'b00000000000000000000000000000000 : n1270;
  /*# cupu_core.vhd:396:9 */
  assign n1272 = regs[607:576]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1273 = n1222 ? 32'b00000000000000000000000000000000 : n1272;
  /*# cupu_core.vhd:396:9 */
  assign n1274 = regs[639:608]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1275 = n1223 ? 32'b00000000000000000000000000000000 : n1274;
  /*# cupu_core.vhd:396:9 */
  assign n1276 = regs[671:640]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1277 = n1224 ? 32'b00000000000000000000000000000000 : n1276;
  /*# cupu_core.vhd:396:9 */
  assign n1278 = regs[703:672]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1279 = n1225 ? 32'b00000000000000000000000000000000 : n1278;
  /*# cupu_core.vhd:396:9 */
  assign n1280 = regs[735:704]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1281 = n1226 ? 32'b00000000000000000000000000000000 : n1280;
  /*# cupu_core.vhd:396:9 */
  assign n1282 = regs[767:736]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1283 = n1227 ? 32'b00000000000000000000000000000000 : n1282;
  /*# cupu_core.vhd:396:9 */
  assign n1284 = regs[799:768]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1285 = n1228 ? 32'b00000000000000000000000000000000 : n1284;
  /*# cupu_core.vhd:396:9 */
  assign n1286 = regs[831:800]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1287 = n1229 ? 32'b00000000000000000000000000000000 : n1286;
  /*# cupu_core.vhd:396:9 */
  assign n1288 = regs[863:832]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1289 = n1230 ? 32'b00000000000000000000000000000000 : n1288;
  /*# cupu_core.vhd:396:9 */
  assign n1290 = regs[895:864]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1291 = n1231 ? 32'b00000000000000000000000000000000 : n1290;
  /*# cupu_core.vhd:396:9 */
  assign n1292 = regs[927:896]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1293 = n1232 ? 32'b00000000000000000000000000000000 : n1292;
  /*# cupu_core.vhd:396:9 */
  assign n1294 = regs[959:928]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1295 = n1233 ? 32'b00000000000000000000000000000000 : n1294;
  /*# cupu_core.vhd:396:9 */
  assign n1296 = regs[991:960]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1297 = n1234 ? 32'b00000000000000000000000000000000 : n1296;
  /*# cupu_core.vhd:396:9 */
  assign n1298 = regs[1023:992]; // extract
  /*# cupu_core.vhd:396:9 */
  assign n1299 = n1235 ? 32'b00000000000000000000000000000000 : n1298;
  /*# cupu_core.vhd:396:9 */
  assign n1300 = {n1299, n1297, n1295, n1293, n1291, n1289, n1287, n1285, n1283, n1281, n1279, n1277, n1275, n1273, n1271, n1269, n1267, n1265, n1263, n1261, n1259, n1257, n1255, n1253, n1251, n1249, n1247, n1245, n1243, n1241, n1239, n1237};
  /*# cupu_core.vhd:398:9 */
  assign n1301 = n708[4]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1302 = ~n1301;
  /*# cupu_core.vhd:398:9 */
  assign n1303 = n708[3]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1304 = ~n1303;
  /*# cupu_core.vhd:398:9 */
  assign n1305 = n1302 & n1304;
  /*# cupu_core.vhd:398:9 */
  assign n1306 = n1302 & n1303;
  /*# cupu_core.vhd:398:9 */
  assign n1307 = n1301 & n1304;
  /*# cupu_core.vhd:398:9 */
  assign n1308 = n1301 & n1303;
  /*# cupu_core.vhd:398:9 */
  assign n1309 = n708[2]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1310 = ~n1309;
  /*# cupu_core.vhd:398:9 */
  assign n1311 = n1305 & n1310;
  /*# cupu_core.vhd:398:9 */
  assign n1312 = n1305 & n1309;
  /*# cupu_core.vhd:398:9 */
  assign n1313 = n1306 & n1310;
  /*# cupu_core.vhd:398:9 */
  assign n1314 = n1306 & n1309;
  /*# cupu_core.vhd:398:9 */
  assign n1315 = n1307 & n1310;
  /*# cupu_core.vhd:398:9 */
  assign n1316 = n1307 & n1309;
  /*# cupu_core.vhd:398:9 */
  assign n1317 = n1308 & n1310;
  /*# cupu_core.vhd:398:9 */
  assign n1318 = n1308 & n1309;
  /*# cupu_core.vhd:398:9 */
  assign n1319 = n708[1]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1320 = ~n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1321 = n1311 & n1320;
  /*# cupu_core.vhd:398:9 */
  assign n1322 = n1311 & n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1323 = n1312 & n1320;
  /*# cupu_core.vhd:398:9 */
  assign n1324 = n1312 & n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1325 = n1313 & n1320;
  /*# cupu_core.vhd:398:9 */
  assign n1326 = n1313 & n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1327 = n1314 & n1320;
  /*# cupu_core.vhd:398:9 */
  assign n1328 = n1314 & n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1329 = n1315 & n1320;
  /*# cupu_core.vhd:398:9 */
  assign n1330 = n1315 & n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1331 = n1316 & n1320;
  /*# cupu_core.vhd:398:9 */
  assign n1332 = n1316 & n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1333 = n1317 & n1320;
  /*# cupu_core.vhd:398:9 */
  assign n1334 = n1317 & n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1335 = n1318 & n1320;
  /*# cupu_core.vhd:398:9 */
  assign n1336 = n1318 & n1319;
  /*# cupu_core.vhd:398:9 */
  assign n1337 = n708[0]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1338 = ~n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1339 = n1321 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1340 = n1321 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1341 = n1322 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1342 = n1322 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1343 = n1323 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1344 = n1323 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1345 = n1324 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1346 = n1324 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1347 = n1325 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1348 = n1325 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1349 = n1326 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1350 = n1326 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1351 = n1327 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1352 = n1327 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1353 = n1328 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1354 = n1328 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1355 = n1329 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1356 = n1329 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1357 = n1330 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1358 = n1330 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1359 = n1331 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1360 = n1331 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1361 = n1332 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1362 = n1332 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1363 = n1333 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1364 = n1333 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1365 = n1334 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1366 = n1334 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1367 = n1335 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1368 = n1335 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1369 = n1336 & n1338;
  /*# cupu_core.vhd:398:9 */
  assign n1370 = n1336 & n1337;
  /*# cupu_core.vhd:398:9 */
  assign n1371 = regs[31:0]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1372 = n1339 ? wb_val : n1371;
  /*# cupu_core.vhd:398:9 */
  assign n1373 = regs[63:32]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1374 = n1340 ? wb_val : n1373;
  /*# cupu_core.vhd:398:9 */
  assign n1375 = regs[95:64]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1376 = n1341 ? wb_val : n1375;
  /*# cupu_core.vhd:398:9 */
  assign n1377 = regs[127:96]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1378 = n1342 ? wb_val : n1377;
  /*# cupu_core.vhd:398:9 */
  assign n1379 = regs[159:128]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1380 = n1343 ? wb_val : n1379;
  /*# cupu_core.vhd:398:9 */
  assign n1381 = regs[191:160]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1382 = n1344 ? wb_val : n1381;
  /*# cupu_core.vhd:398:9 */
  assign n1383 = regs[223:192]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1384 = n1345 ? wb_val : n1383;
  /*# cupu_core.vhd:398:9 */
  assign n1385 = regs[255:224]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1386 = n1346 ? wb_val : n1385;
  /*# cupu_core.vhd:398:9 */
  assign n1387 = regs[287:256]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1388 = n1347 ? wb_val : n1387;
  /*# cupu_core.vhd:398:9 */
  assign n1389 = regs[319:288]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1390 = n1348 ? wb_val : n1389;
  /*# cupu_core.vhd:398:9 */
  assign n1391 = regs[351:320]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1392 = n1349 ? wb_val : n1391;
  /*# cupu_core.vhd:398:9 */
  assign n1393 = regs[383:352]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1394 = n1350 ? wb_val : n1393;
  /*# cupu_core.vhd:398:9 */
  assign n1395 = regs[415:384]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1396 = n1351 ? wb_val : n1395;
  /*# cupu_core.vhd:398:9 */
  assign n1397 = regs[447:416]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1398 = n1352 ? wb_val : n1397;
  /*# cupu_core.vhd:398:9 */
  assign n1399 = regs[479:448]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1400 = n1353 ? wb_val : n1399;
  /*# cupu_core.vhd:398:9 */
  assign n1401 = regs[511:480]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1402 = n1354 ? wb_val : n1401;
  /*# cupu_core.vhd:398:9 */
  assign n1403 = regs[543:512]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1404 = n1355 ? wb_val : n1403;
  /*# cupu_core.vhd:398:9 */
  assign n1405 = regs[575:544]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1406 = n1356 ? wb_val : n1405;
  /*# cupu_core.vhd:398:9 */
  assign n1407 = regs[607:576]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1408 = n1357 ? wb_val : n1407;
  /*# cupu_core.vhd:398:9 */
  assign n1409 = regs[639:608]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1410 = n1358 ? wb_val : n1409;
  /*# cupu_core.vhd:398:9 */
  assign n1411 = regs[671:640]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1412 = n1359 ? wb_val : n1411;
  /*# cupu_core.vhd:398:9 */
  assign n1413 = regs[703:672]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1414 = n1360 ? wb_val : n1413;
  /*# cupu_core.vhd:398:9 */
  assign n1415 = regs[735:704]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1416 = n1361 ? wb_val : n1415;
  /*# cupu_core.vhd:398:9 */
  assign n1417 = regs[767:736]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1418 = n1362 ? wb_val : n1417;
  /*# cupu_core.vhd:398:9 */
  assign n1419 = regs[799:768]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1420 = n1363 ? wb_val : n1419;
  /*# cupu_core.vhd:398:9 */
  assign n1421 = regs[831:800]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1422 = n1364 ? wb_val : n1421;
  /*# cupu_core.vhd:398:9 */
  assign n1423 = regs[863:832]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1424 = n1365 ? wb_val : n1423;
  /*# cupu_core.vhd:398:9 */
  assign n1425 = regs[895:864]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1426 = n1366 ? wb_val : n1425;
  /*# cupu_core.vhd:398:9 */
  assign n1427 = regs[927:896]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1428 = n1367 ? wb_val : n1427;
  /*# cupu_core.vhd:398:9 */
  assign n1429 = regs[959:928]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1430 = n1368 ? wb_val : n1429;
  /*# cupu_core.vhd:398:9 */
  assign n1431 = regs[991:960]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1432 = n1369 ? wb_val : n1431;
  /*# cupu_core.vhd:398:9 */
  assign n1433 = regs[1023:992]; // extract
  /*# cupu_core.vhd:398:9 */
  assign n1434 = n1370 ? wb_val : n1433;
  /*# cupu_core.vhd:398:9 */
  assign n1435 = {n1434, n1432, n1430, n1428, n1426, n1424, n1422, n1420, n1418, n1416, n1414, n1412, n1410, n1408, n1406, n1404, n1402, n1400, n1398, n1396, n1394, n1392, n1390, n1388, n1386, n1384, n1382, n1380, n1378, n1376, n1374, n1372};
endmodule

module tt_um_zonlykroks_cupu
  (input  [7:0] ui_in,
   output [7:0] uo_out,
   input  [7:0] uio_in,
   output [7:0] uio_out,
   output [7:0] uio_oe,
   input  ena,
   input  clk,
   input  rst_n);
  wire rst;
  wire mem_req;
  wire mem_we;
  wire mem_done;
  wire [1:0] mem_size;
  wire [23:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [31:0] mem_rdata;
  wire sck;
  wire mosi;
  wire [1:0] cs_n;
  wire n3;
  wire [7:0] \core.gpio_out ;
  wire \core.halted ;
  wire n14;
  wire n20;
  wire n21;
  wire n23;
  wire [7:0] n24;
  wire [7:0] n26;
  assign uo_out = \core.gpio_out ; //(module output)
  assign uio_out = n26; //(module output)
  assign uio_oe = n24; //(module output)
  /*# tt_um_zonlykroks_cupu.vhd:27:10 */
  assign rst = n3; // (signal)
  /*# tt_um_zonlykroks_cupu.vhd:38:10 */
  assign n3 = ~rst_n;
  /*# tt_um_zonlykroks_cupu.vhd:40:3 */
  cupu_core_Brtl_25000000 core (
    .clk(clk),
    .rst(rst),
    .mem_rdata(mem_rdata),
    .mem_done(mem_done),
    .kbd_in(ui_in),
    .mem_req(mem_req),
    .mem_we(mem_we),
    .mem_size(mem_size),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .gpio_out(\core.gpio_out ),
    .halted());
  /*# tt_um_zonlykroks_cupu.vhd:57:3 */
  cupu_spi_Brtl spi (
    .clk(clk),
    .rst(rst),
    .req(mem_req),
    .we(mem_we),
    .size(mem_size),
    .addr(mem_addr),
    .wdata(mem_wdata),
    .miso(n14),
    .rdata(mem_rdata),
    .done(mem_done),
    .sck(sck),
    .mosi(mosi),
    .cs_n(cs_n));
  /*# tt_um_zonlykroks_cupu.vhd:70:22 */
  assign n14 = uio_in[2]; // extract
  /*# tt_um_zonlykroks_cupu.vhd:80:21 */
  assign n20 = cs_n[0]; // extract
  /*# tt_um_zonlykroks_cupu.vhd:81:21 */
  assign n21 = cs_n[1]; // extract
  /*# tt_um_zonlykroks_cupu.vhd:83:30 */
  assign n23 = ~rst_n;
  /*# tt_um_zonlykroks_cupu.vhd:83:19 */
  assign n24 = n23 ? 8'b00000000 : 8'b11001011;
  /*# tt_um_zonlykroks_cupu.vhd:18:5 */
  assign n26 = {n21, n20, 1'b0, 1'b0, sck, 1'b0, mosi, 1'b1};
endmodule

