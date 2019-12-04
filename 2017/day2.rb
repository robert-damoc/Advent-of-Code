def first_quiz
  input = [
    %w(409	194	207	470	178	454	235	333	511	103	474	293	525	372	408	428),
    %w(4321	2786	6683	3921	265	262	6206	2207	5712	214	6750	2742	777	5297	3764	167),
    %w(3536	2675	1298	1069	175	145	706	2614	4067	4377	146	134	1930	3850	213	4151),
    %w(2169	1050	3705	2424	614	3253	222	3287	3340	2637	61	216	2894	247	3905	214),
    %w(99	797	80	683	789	92	736	318	103	153	749	631	626	367	110	805),
    %w(2922	1764	178	3420	3246	3456	73	2668	3518	1524	273	2237	228	1826	182	2312),
    %w(2304	2058	286	2258	1607	2492	2479	164	171	663	62	144	1195	116	2172	1839),
    %w(114	170	82	50	158	111	165	164	106	70	178	87	182	101	86	168),
    %w(121	110	51	122	92	146	13	53	34	112	44	160	56	93	82	98),
    %w(4682	642	397	5208	136	4766	180	1673	1263	4757	4680	141	4430	1098	188	1451),
    %w(158	712	1382	170	550	913	191	163	459	1197	1488	1337	900	1182	1018	337),
    %w(4232	236	3835	3847	3881	4180	4204	4030	220	1268	251	4739	246	3798	1885	3244),
    %w(169	1928	3305	167	194	3080	2164	192	3073	1848	426	2270	3572	3456	217	3269),
    %w(140	1005	2063	3048	3742	3361	117	93	2695	1529	120	3480	3061	150	3383	190),
    %w(489	732	57	75	61	797	266	593	324	475	733	737	113	68	267	141),
    %w(3858	202	1141	3458	2507	239	199	4400	3713	3980	4170	227	3968	1688	4352	4168)
  ]
  output = 0

  input.each do |line|
    line.map!(&:to_i).sort!
    output += (line.last - line.first)
  end

  output
end

def second_quiz
  input = [
    %w(409	194	207	470	178	454	235	333	511	103	474	293	525	372	408	428),
    %w(4321	2786	6683	3921	265	262	6206	2207	5712	214	6750	2742	777	5297	3764	167),
    %w(3536	2675	1298	1069	175	145	706	2614	4067	4377	146	134	1930	3850	213	4151),
    %w(2169	1050	3705	2424	614	3253	222	3287	3340	2637	61	216	2894	247	3905	214),
    %w(99	797	80	683	789	92	736	318	103	153	749	631	626	367	110	805),
    %w(2922	1764	178	3420	3246	3456	73	2668	3518	1524	273	2237	228	1826	182	2312),
    %w(2304	2058	286	2258	1607	2492	2479	164	171	663	62	144	1195	116	2172	1839),
    %w(114	170	82	50	158	111	165	164	106	70	178	87	182	101	86	168),
    %w(121	110	51	122	92	146	13	53	34	112	44	160	56	93	82	98),
    %w(4682	642	397	5208	136	4766	180	1673	1263	4757	4680	141	4430	1098	188	1451),
    %w(158	712	1382	170	550	913	191	163	459	1197	1488	1337	900	1182	1018	337),
    %w(4232	236	3835	3847	3881	4180	4204	4030	220	1268	251	4739	246	3798	1885	3244),
    %w(169	1928	3305	167	194	3080	2164	192	3073	1848	426	2270	3572	3456	217	3269),
    %w(140	1005	2063	3048	3742	3361	117	93	2695	1529	120	3480	3061	150	3383	190),
    %w(489	732	57	75	61	797	266	593	324	475	733	737	113	68	267	141),
    %w(3858	202	1141	3458	2507	239	199	4400	3713	3980	4170	227	3968	1688	4352	4168)
  ]
  output = 0

  input.each do |line|
    line.map!(&:to_i).sort!
    line.each_with_index do |n, i|
      nr = line[i + 1..line.length].find { |nr| nr % n == 0 }
      if nr
        output += (nr / n)
        break
      end
    end
  end

  output
end

# p "first_quiz: #{first_quiz}"
p "second_quiz: #{second_quiz}"
