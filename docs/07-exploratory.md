# Exploratory Analysis {#exploratory}

<!--  You can label chapter and section titles using `{#label}` after them, e.g., we can reference Chapter \@ref(intro). If you do not manually label them, there will be automatic labels anyway, e.g., Chapter \@ref(methods).-->



Data comes packed into the REST API end point `*/complete` in .json format. Data can be filtered out On the basis of the options set in the API endpoint argument body. Some of the options might regard the `city` in which it is aevaluated the real estate market, `npages` as the number of pages to be scraped, `type` as the choice between rental of selling. For further documentation on how to structure the API endpoint query refer to section \@ref(APIdocs).  Since to the analysis purposes data should come from the same source (e.g. Milan rental real estate within "circonvallazione") a dedicated endpoint boolean option `.thesis` is passed in the argument body. What the API option under the hood is doing is specifying a structured and already filtered URL to be passed to the scraping endppoint. By securing the same URL to the scraping functions data is forced to come from the same URL source. The idea behind this concept can be thought as refreshing everyday the same immobiliare.it URL. API endpoint by default also specifies 10 pages to be scraped, in this case 120 is provided leading to to 3000 data points. The `*` refers to the EC2 public DNS that is `ec2-18-224-40-67.us-east-2.compute.amazonaws.com`

`http://*/complete/120/milano/affitto/.thesis=true`

As a further source data can also be accessed through the mondgoDB credentials with the cloud ATLAS database by picking up the latest .csv file generated. For run time reasons also related to the bookdown files continuous building the API endpoint is called the day before the presentation so that the latest .csv file is available. As a consequence code chunks outputs are all cached due to heavy computation.
Interactive  maps are done with Leaflet, the result of which is a leaflet map object which can be piped to other leaflet functions. This permits multiple map layers and many control options to be added interactively (LaTex output is statically generated)

A preliminary API data exploratory analysis evidences 34 covariates and 250 rows, which are once again conditioned to the query sent to the API. Immobiliare.it furnishes many information regarding property attributes and estate agency circumstances. Data displays many NA in some of the columns but georeference coordinates, due to the design of scraping functions, are in any case present. 



<table>
 <thead>
  <tr>
   <th style="text-align:left;"> name </th>
   <th style="text-align:left;"> ref </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ID </td>
   <td style="text-align:left;"> ID of the apartements </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LAT </td>
   <td style="text-align:left;"> latitude coordinate </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LONG </td>
   <td style="text-align:left;"> longitude coordinate </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOCATION </td>
   <td style="text-align:left;"> the complete address: street name and number </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CONDOM </td>
   <td style="text-align:left;"> the condominium monthly expenses </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUILDAGE </td>
   <td style="text-align:left;"> the age in which the building was contructed </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FLOOR </td>
   <td style="text-align:left;"> the property floor </td>
  </tr>
  <tr>
   <td style="text-align:left;"> INDIVSAPT </td>
   <td style="text-align:left;"> indipendent property type versus apartement type </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOCALI </td>
   <td style="text-align:left;"> specification of the type and number of rooms </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TPPROP </td>
   <td style="text-align:left;"> property type residential or not </td>
  </tr>
  <tr>
   <td style="text-align:left;"> STATUS </td>
   <td style="text-align:left;"> the actual status of the house, ristrutturato, nuovo, abitabile </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HEATING </td>
   <td style="text-align:left;"> the heating system Cen_Rad_Gas (centralizzato a radiatori, alim a gas), Cen_Rad_Met, </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AC </td>
   <td style="text-align:left;"> air conditioning hot and cold, Autonomo, freddo/caldo, Centralizzato, freddo/caldo </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PUB_DATE </td>
   <td style="text-align:left;"> the date of publication of the advertisement </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CATASTINFO </td>
   <td style="text-align:left;"> land registry information </td>
  </tr>
  <tr>
   <td style="text-align:left;"> APTCHAR </td>
   <td style="text-align:left;"> apartement main characteristics </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PHOTOSNUM </td>
   <td style="text-align:left;"> number of photos displayed in the advertisement </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AGE </td>
   <td style="text-align:left;"> real estate agency name </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOWRDPRICE.originalPrice </td>
   <td style="text-align:left;"> If the price is lowered it flags the starting price </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOWRDPRICE.currentPrice </td>
   <td style="text-align:left;"> If the price is lowered it flags the current price </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOWRDPRICE.passedDays </td>
   <td style="text-align:left;"> If the price is lowered indicates the days passed since the price has changed </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOWRDPRICE.date </td>
   <td style="text-align:left;"> If the price is lowered indicates the date the price has changed </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ENCLASS </td>
   <td style="text-align:left;"> the energy class according to the land registers </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CONTR </td>
   <td style="text-align:left;"> the type of contract </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DISP </td>
   <td style="text-align:left;"> if it is still avaiable or already rented </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TOTPIANI </td>
   <td style="text-align:left;"> the total number of the building floors </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PAUTO </td>
   <td style="text-align:left;"> number of parking box or garages avaibable in the property </td>
  </tr>
  <tr>
   <td style="text-align:left;"> REVIEW </td>
   <td style="text-align:left;"> estate agency review, long chr string </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HASMULTI </td>
   <td style="text-align:left;"> it if has multimedia option, such as 3D house vitualization home experience or videos </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PRICE </td>
   <td style="text-align:left;"> the monthly price &lt;- response </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SQFEET </td>
   <td style="text-align:left;"> square meters footage </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NROOM </td>
   <td style="text-align:left;"> the number of rooms in the house, and their types </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TITLE </td>
   <td style="text-align:left;"> title of published advertisement </td>
  </tr>
</tbody>
</table>


## Data preparation 



Data needs to undergo to many previous cleaning preprocess steps, this is a forced stage since API comes in human readable format, which is from one hanb designed to a be readble format, but from the other it is not prepared to be modeled. cleaning steps mainly regards:

- encoding from UTF-8 to Latin due to Italian characters incorrectly parsed.
- *FLOORS* covariate needs to be separated by its *ASCENSORE* and *ACCDISABILI* components, leading to have 2 further bivariate covariates.
- *LOCALI* needs to undergo to be separated in its components too. 5 categories levels drain out: *TOTLOCALI*, *CAMERELETTO*, *ALTRO*, *BAGNO*, *CUCINA*. *TOTLOCALI* is a duplicate for *NROOM* the is discarded.
- *APTCHAR* is a list column so that each observation has different categories insiside. The preprocess step includes unnesting the list by creating as many bivariate columns as elements in the list. Then new columns flag the existemce of the caracteristics in the apartement. A slice for the fist observation displays:

- - fibra ottica- - - videocitofono- - - impianto di allarme- - - porta blindata- - - reception- - - balcone- - - portiere intera giornata- - - impianto tv centralizzato- - - parzialmente arredato- - - esposizione doppia- -

(sistemare classe energetica)


### Maps and Geo-Visualisations

Geographic coordinates can be represented on a map in order to reveal first symptoms of spatial autocorrelation. Observations are spread almost equally throughout the surface even though the response var *PRICE* indicates unsurprisingly that higher prices are nearer to the city center.
The map in figure \@ref(fig:leaflet_visuals) is a leaflet object, which can needs to be overlapped with layers indicating different maps projections. This is interactive in the .html version, and static is proposed in the .pdf output version. The map object takes a input the latitute and longitude coordinates coming from THE API, and they do not need any CRS (Coordinate Reference System) projection since leaflet can accept the data type.

<div class="figure">
<!--html_preserve--><div id="htmlwidget-2c3bbfcc70bc1182ac74" style="width:100%;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-2c3bbfcc70bc1182ac74">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"setView":[[45.474211,9.191383],13,[]],"calls":[{"method":"addMiniMap","args":[null,null,"bottomright",150,150,19,19,-5,false,false,false,false,false,false,{"color":"#ff7800","weight":1,"clickable":false},{"color":"#000000","weight":1,"clickable":false,"opacity":0,"fillOpacity":0},{"hideText":"Hide MiniMap","showText":"Show MiniMap"},[]]},{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircles","args":[[45.477,45.4709,45.4605,45.4709,45.4709,45.476,45.4753,45.4694,45.4813,45.4771,45.4534,45.4612,45.4969,45.4919,45.4825,45.4513,45.4495,45.4732,45.4632,45.4657,45.4481,45.4444,45.4555,45.4794,45.4659,45.4694,45.4706,45.4877,45.4815,45.4824,45.4781,45.4488,45.4668,45.4593,45.4731,45.4813,45.4771,45.4805,45.471,45.4705,45.49,45.4566,45.4608,45.4439,45.4921,45.4705,45.4528,45.4795,45.4733,45.4596,45.4616,45.4699,45.4568,45.49,45.4826,45.4747,45.4567,45.4569,45.4759,45.4863,45.4777,45.4712,45.4604,45.4647,45.4917,45.4746,45.4717,45.4618,45.4836,45.4656,45.4642,45.452,45.4725,45.4833,45.4573,45.4477,45.4865,45.4729,45.4789,45.455,45.4669,45.4515,45.4699,45.4683,45.4914,45.4809,45.4648,45.4797,45.4583,45.4631,45.4592,45.4547,45.4568,45.4693,45.4583,45.4747,45.4567,45.4616,45.472,45.4823,45.4615,45.4726,45.4801,45.4626,45.4621,45.4684,45.4778,45.4805,45.4529,45.4847,45.4597,45.4631,45.4467,45.459,45.4897,45.4551,45.4472,45.4472,45.4657,45.4467,45.4779,45.4897,45.4468,45.4722,45.4726,45.4865,45.4761,45.4656,45.4701,45.4701,45.4467,45.4707,45.4584,45.4567,45.4773,45.4659,45.4856,45.4513,45.4668,45.4584,45.4812,45.4628,45.4511,45.4774,45.487,45.4769,45.4482,45.4643,45.4843,45.4879,45.4897,45.4621,45.4878,45.477,45.4876,45.4842,45.488,45.4793,45.4548,45.4668,45.4654,45.4702,45.4819,45.4432,45.4668,45.4657,45.4747,45.4674,45.4897,45.4714,45.478,45.4662,45.4729,45.4783,45.4666,45.4572,45.4709,45.4656,45.4859,45.474,45.4879,45.48,45.4909,45.4787,45.4909,45.4651,45.4674,45.4581,45.4583,45.4461,45.4659,45.4715,45.4558,45.4669,45.4634,45.4512,45.4574,45.4857,45.4639,45.4554,45.4514,45.4593,45.4723,45.4733,45.4797,45.476,45.4815,45.4464,45.4737,45.4797,45.4878,45.4887,45.4863,45.4734,45.4812,45.49,45.4739,45.4729,45.4449,45.4814,45.456,45.467,45.4544,45.4677,45.4863,45.4713,45.4547,45.4452,45.4705,45.4897,45.4895,45.5036,45.4564,45.4726,45.4583,45.4681,45.4671,45.4664,45.4701,45.4791,45.4779,45.4708,45.459,45.4878,45.4748,45.4732,45.4725,45.4785,45.4765,45.471],[9.15101,9.20868,9.18927,9.20868,9.20868,9.2116,9.205,9.1583,9.1884,9.20441,9.2193,9.2035,9.1853,9.2077,9.1736,9.1852,9.1996,9.2063,9.22367,9.1708,9.1769,9.1764,9.1875,9.1877,9.2064,9.2186,9.1517,9.2027,9.2102,9.1851,9.1899,9.1617,9.2159,9.2071,9.1887,9.1792,9.1842,9.2126,9.1876,9.1963,9.2191,9.207,9.2307,9.1802,9.1861,9.2035,9.19494,9.216,9.2144,9.1797,9.19053,9.1867,9.2147,9.1645,9.2005,9.1834,9.1873,9.2143,9.1708,9.2336,9.17866,9.19181,9.1765,9.1664,9.2184,9.2221,9.2035,9.2144,9.1677,9.152,9.1988,9.1783,9.1886,9.17095,9.1805,9.159,9.188,9.2133,9.1785,9.1668,9.1973,9.156,9.18366,9.16652,9.18645,9.1998,9.1566,9.2195,9.2071,9.1988,9.2008,9.17209,9.21036,9.19777,9.1541,9.18837,9.1749,9.2213,9.23739,9.22107,9.1552,9.1859,9.2031,9.2,9.2098,9.1776,9.188,9.192,9.1663,9.1626,9.207,9.1808,9.18773,9.2139,9.2059,9.2001,9.1981,9.1789,9.2307,9.19687,9.211,9.203,9.1656,9.21577,9.1924,9.1901,9.2242,9.2055,9.19498,9.1905,9.1637,9.20858,9.1859,9.1873,9.2103,9.21327,9.1976,9.17325,9.156,9.1809,9.2253,9.1812,9.19242,9.2159,9.1568,9.2169,9.1886,9.1794,9.1636,9.187,9.1831,9.2034,9.22375,9.15101,9.1861,9.17174,9.18815,9.18943,9.18425,9.22555,9.21241,9.16526,9.1558,9.21717,9.1505,9.20925,9.20954,9.1523,9.22575,9.2005,9.18341,9.18085,9.1872,9.2192,9.16,9.17552,9.148,9.18,9.1536,9.182,9.1854,9.1659,9.1864,9.1612,9.1864,9.20754,9.15785,9.1611,9.2076,9.1787,9.1836,9.19277,9.1536,9.18362,9.2096,9.177,9.17329,9.1523,9.1809,9.17614,9.2009,9.1726,9.1969,9.1878,9.1606,9.2103,9.21866,9.177,9.2091,9.1933,9.15496,9.2256,9.1601,9.15177,9.17738,9.20619,9.19306,9.1847,9.1792,9.2058,9.19941,9.18167,9.1738,9.16242,9.156,9.1842,9.18042,9.1721,9.1841,9.1486,9.1675,9.1932,9.2119,9.1924,9.1523,9.1919,9.2018,9.15971,9.197,9.18407,9.17939,9.21233,9.1803,9.1913,9.1442,9.21961,9.2279,9.2225,9.1603,9.1876],[7.80384330353877,7.09007683577609,8.00636756765025,7.17011954344963,7.43838353004431,8.25582842728183,8.51719319141624,7.97796809312855,7.97246601597457,7.09007683577609,6.39692965521615,8.1605182474775,6.90775527898214,7.27931883541462,6.95654544315157,7.22620901010067,6.62007320653036,7.97246601597457,6.95654544315157,7.3132203870903,6.90775527898214,7.00306545878646,7.52294091807237,6.95654544315157,7.3132203870903,7.71868549519847,7.3132203870903,7.09007683577609,6.69703424766648,6.80239476332431,7.60090245954208,7.09007683577609,7.09007683577609,6.75693238924755,7.69621263934641,7.43838353004431,7.90100705199242,7.43838353004431,7.82404601085629,7.91935619066062,6.80239476332431,7.20785987143248,6.86484777797086,6.47697236288968,7.09007683577609,8.20685642839965,8.1605182474775,7.00306545878646,7.09007683577609,7.00306545878646,7.34601020991329,7.54960916515453,6.74523634948436,7.3132203870903,7.54960916515453,7.60090245954208,7.43838353004431,7.24422751560335,7.26542972325395,7.37775890822787,6.68461172766793,8.1605182474775,7.0475172213573,7.90100705199242,6.7093043402583,7.60090245954208,8.00636756765025,7.00306545878646,7.27239839257005,6.84587987526405,7.00306545878646,8.00636756765025,8.00636756765025,6.80239476332431,6.8351845861473,6.85646198459459,6.5510803350434,7.09007683577609,7.0475172213573,6.85646198459459,7.5137092478397,7.09007683577609,7.43838353004431,7.17011954344963,7.00306545878646,7.82404601085629,7.54960916515453,7.54960916515453,7.3132203870903,8.1605182474775,7.20785987143248,7.60090245954208,7.0343879299155,7.68017564043659,6.80239476332431,7.60090245954208,7.13089883029635,7.82404601085629,6.85646198459459,6.30991827822652,7.3132203870903,8.00636756765025,7.17011954344963,7.87283617502572,6.74523634948436,8.00636756765025,7.69621263934641,7.9373746961633,7.24422751560335,7.24422751560335,6.5510803350434,8.06148686687133,7.13089883029635,7.24422751560335,6.47697236288968,6.74523634948436,7.24422751560335,7.37775890822787,6.74523634948436,7.43838353004431,7.3132203870903,7.60090245954208,6.68461172766793,7.69621263934641,8.07090608878782,6.62007320653036,7.17011954344963,7.52294091807237,8.33086361322474,8.41183267575841,7.09007683577609,7.43838353004431,7.07326971745971,7.3132203870903,6.85646198459459,7.60090245954208,7.20785987143248,6.90775527898214,7.20785987143248,6.86693328446188,7.37775890822787,8.85366542803745,6.80239476332431,7.00306545878646,6.39692965521615,6.68461172766793,7.00306545878646,8.1605182474775,7.09007683577609,6.80239476332431,6.85646198459459,7.52294091807237,6.94697599213542,7.54960916515453,7.13089883029635,7.17011954344963,6.74523634948436,7.60090245954208,6.74523634948436,7.43248380791712,7.09007683577609,7.7621706071382,6.90775527898214,7.17011954344963,7.20785987143248,6.90775527898214,7.09007683577609,7.00306545878646,6.50279004591562,8.20658361432075,8.10167774745457,7.60090245954208,7.40853056689463,7.99967857949945,7.09007683577609,7.34601020991329,7.3132203870903,7.40853056689463,7.00306545878646,7.34601020991329,6.85646198459459,7.62559507213245,7.27931883541462,6.85646198459459,6.47697236288968,7.24422751560335,7.3132203870903,7.20785987143248,6.90775527898214,7.40853056689463,7.09007683577609,8.80986280537906,7.43838353004431,8.1605182474775,6.85646198459459,6.80239476332431,7.69621263934641,7.24422751560335,8.74033674273045,7.17011954344963,6.68461172766793,7.60090245954208,7.37462901521894,7.29979736675816,7.34601020991329,7.39326309476384,6.47697236288968,7.13886699994552,6.80239476332431,8.26873183211774,6.80239476332431,7.3132203870903,7.03878354138854,7.24422751560335,6.47697236288968,6.5510803350434,8.69951474821019,8.00636756765025,6.39692965521615,6.90775527898214,6.90775527898214,7.60090245954208,6.80239476332431,6.74523634948436,6.80239476332431,7.78322401633604,7.17011954344963,7.17011954344963,8.33495163142245,6.85646198459459,6.77992190747225,6.68461172766793,7.24422751560335,8.1605182474775,7.13089883029635,8.59415423255237,7.82404601085629,7.40853056689463,7.41878088275079,7.9373746961633,7.00306545878646,8.29404964010203,7.60090245954208,8.29404964010203,7.34601020991329,7.34601020991329,7.09007683577609,7.74066440191724,7.46737106691756,7.62559507213245],null,null,{"interactive":true,"className":"","stroke":true,"color":["#35B779","#440154","#FDE725","#440154","#31688E","#FDE725","#FDE725","#FDE725","#FDE725","#440154","#808080","#FDE725","#440154","#440154","#440154","#440154","#808080","#FDE725","#440154","#31688E","#440154","#440154","#31688E","#440154","#31688E","#35B779","#31688E","#440154","#808080","#808080","#35B779","#440154","#440154","#808080","#35B779","#31688E","#FDE725","#31688E","#FDE725","#FDE725","#808080","#440154","#808080","#808080","#440154","#FDE725","#FDE725","#440154","#440154","#440154","#31688E","#31688E","#808080","#31688E","#31688E","#35B779","#31688E","#440154","#440154","#31688E","#808080","#FDE725","#440154","#FDE725","#808080","#35B779","#FDE725","#440154","#440154","#808080","#440154","#FDE725","#FDE725","#808080","#808080","#808080","#808080","#440154","#440154","#808080","#31688E","#440154","#31688E","#440154","#440154","#FDE725","#31688E","#31688E","#31688E","#FDE725","#440154","#35B779","#440154","#35B779","#808080","#35B779","#440154","#FDE725","#808080","#808080","#31688E","#FDE725","#440154","#FDE725","#808080","#FDE725","#35B779","#FDE725","#440154","#440154","#808080","#FDE725","#440154","#440154","#808080","#808080","#440154","#31688E","#808080","#31688E","#31688E","#35B779","#808080","#35B779","#FDE725","#808080","#440154","#31688E","#FDE725","#FDE725","#440154","#31688E","#440154","#31688E","#808080","#35B779","#440154","#440154","#440154","#808080","#31688E","#808080","#808080","#440154","#808080","#808080","#440154","#FDE725","#440154","#808080","#808080","#31688E","#440154","#31688E","#440154","#440154","#808080","#35B779","#808080","#31688E","#440154","#35B779","#440154","#440154","#440154","#440154","#440154","#440154","#808080","#FDE725","#FDE725","#35B779","#31688E","#FDE725","#440154","#31688E","#31688E","#31688E","#440154","#31688E","#808080","#35B779","#440154","#808080","#808080","#440154","#31688E","#440154","#440154","#31688E","#440154","#808080","#31688E","#FDE725","#808080","#808080","#35B779","#440154","#808080","#440154","#808080","#35B779","#31688E","#440154","#31688E","#31688E","#808080","#440154","#808080","#FDE725","#808080","#31688E","#440154","#440154","#808080","#808080","#808080","#FDE725","#808080","#440154","#440154","#35B779","#808080","#808080","#808080","#35B779","#440154","#440154","#FDE725","#808080","#808080","#808080","#440154","#FDE725","#440154","#808080","#FDE725","#31688E","#31688E","#FDE725","#440154","#FDE725","#35B779","#FDE725","#31688E","#31688E","#440154","#35B779","#31688E","#35B779"],"weight":10,"opacity":0.5,"fill":true,"fillColor":["#35B779","#440154","#FDE725","#440154","#31688E","#FDE725","#FDE725","#FDE725","#FDE725","#440154","#808080","#FDE725","#440154","#440154","#440154","#440154","#808080","#FDE725","#440154","#31688E","#440154","#440154","#31688E","#440154","#31688E","#35B779","#31688E","#440154","#808080","#808080","#35B779","#440154","#440154","#808080","#35B779","#31688E","#FDE725","#31688E","#FDE725","#FDE725","#808080","#440154","#808080","#808080","#440154","#FDE725","#FDE725","#440154","#440154","#440154","#31688E","#31688E","#808080","#31688E","#31688E","#35B779","#31688E","#440154","#440154","#31688E","#808080","#FDE725","#440154","#FDE725","#808080","#35B779","#FDE725","#440154","#440154","#808080","#440154","#FDE725","#FDE725","#808080","#808080","#808080","#808080","#440154","#440154","#808080","#31688E","#440154","#31688E","#440154","#440154","#FDE725","#31688E","#31688E","#31688E","#FDE725","#440154","#35B779","#440154","#35B779","#808080","#35B779","#440154","#FDE725","#808080","#808080","#31688E","#FDE725","#440154","#FDE725","#808080","#FDE725","#35B779","#FDE725","#440154","#440154","#808080","#FDE725","#440154","#440154","#808080","#808080","#440154","#31688E","#808080","#31688E","#31688E","#35B779","#808080","#35B779","#FDE725","#808080","#440154","#31688E","#FDE725","#FDE725","#440154","#31688E","#440154","#31688E","#808080","#35B779","#440154","#440154","#440154","#808080","#31688E","#808080","#808080","#440154","#808080","#808080","#440154","#FDE725","#440154","#808080","#808080","#31688E","#440154","#31688E","#440154","#440154","#808080","#35B779","#808080","#31688E","#440154","#35B779","#440154","#440154","#440154","#440154","#440154","#440154","#808080","#FDE725","#FDE725","#35B779","#31688E","#FDE725","#440154","#31688E","#31688E","#31688E","#440154","#31688E","#808080","#35B779","#440154","#808080","#808080","#440154","#31688E","#440154","#440154","#31688E","#440154","#808080","#31688E","#FDE725","#808080","#808080","#35B779","#440154","#808080","#440154","#808080","#35B779","#31688E","#440154","#31688E","#31688E","#808080","#440154","#808080","#FDE725","#808080","#31688E","#440154","#440154","#808080","#808080","#808080","#FDE725","#808080","#440154","#440154","#35B779","#808080","#808080","#808080","#35B779","#440154","#440154","#FDE725","#808080","#808080","#808080","#440154","#FDE725","#440154","#808080","#FDE725","#31688E","#31688E","#FDE725","#440154","#FDE725","#35B779","#FDE725","#31688E","#31688E","#440154","#35B779","#31688E","#35B779"],"fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]},{"method":"addLegend","args":[{"colors":["#440154","#31688E","#35B779","#FDE725"],"labels":["1,000 &ndash; 1,500","1,500 &ndash; 2,000","2,000 &ndash; 2,500","2,500 &ndash; 5,000"],"na_color":null,"na_label":"NA","opacity":0.5,"position":"bottomright","type":"bin","title":"Prices","extra":null,"layerId":null,"className":"info legend","group":null}]},{"method":"addScaleBar","args":[{"maxWidth":100,"metric":true,"imperial":true,"updateWhenIdle":true,"position":"bottomleft"}]}],"limits":{"lat":[45.4432,45.5036],"lng":[9.1442,9.23739]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:leaflet_visuals)Leaflet Map</p>
</div>

(other more tmap and ggplot)

## Counts and First Orientations

Arranged Counts for categorical columns can give a sense of the distribution of categories across the dataset suggesting also which predictor to include in the model. The visualization in figure \@ref(fig:counts) offers a a reordered *TOTLOCALI* 5 levels categories. Bilocali are the most common option for rent, then trilocali comes at second place. The intuition behind suggests that Milan rental market is oriented to "lighter" accommodation solutions in terms of space and squarefootage. This should comes natural since Milan is both a vivid study and working area, so short stayings are warmly welcomed

<div class="figure">
<img src="07-exploratory_files/figure-html/fct_counts-1.png" alt="Most common housedolds categories for Milan Real Estate Market" width="672" />
<p class="caption">(\#fig:fct_counts)Most common housedolds categories for Milan Real Estate Market</p>
</div>

Two of the most requested features for comfort and livability in rents are the heating/cooling systems installed. Moreover rental market demand regardless of the total house rent duration ready-to accomodate solutions, coming with all the services included.
x-axis in figure \@ref(fig:price_per_heating) represents log_10 price for both of the two plots for smoothing reasons, so the interpretation of price is into relative percent changes. Furthermore factors are reordered with respect to decreasing price.  
y-axis are the different level for the categorical variables recoded to simplify lables. Moreover counts per level are expressed btween brackets next to the the respective levels.
The top plot displays the most prevalent categories  is "Cen_Rad_Met" by far, which is the most polluting as well. Jittering is then applied to highlight observations place with respect to the IQR (Inter Quantile Range) .25 and how outliers affect distribution for categories. A first conclusion is that There are some outliers that are located in autonomous systems, which leads to belive that the most expsive houses are heated by autonomoius heating systems, but that does not represent an implication in monthly price. The overlapping IQR signifies that the covariates levels do not impact the response variable.

<div class="figure">
<img src="07-exploratory_files/figure-html/price_heating_ac-1.png" alt="Log Monthly Price per Heating and AC system" width="672" />
<p class="caption">(\#fig:price_heating_ac)Log Monthly Price per Heating and AC system</p>
</div>

<div class="figure">
<img src="07-exploratory_files/figure-html/price_per_ac-1.png" alt="Log Monthly Price per Heating system?" width="672" />
<p class="caption">(\#fig:price_per_ac-1)Log Monthly Price per Heating system?</p>
</div><div class="figure">
<img src="07-exploratory_files/figure-html/price_per_ac-2.png" alt="Log Monthly Price per Heating system?" width="672" />
<p class="caption">(\#fig:price_per_ac-2)Log Monthly Price per Heating system?</p>
</div>



```
## # A tibble: 8 x 2
##   AC                              n
##   <chr>                       <int>
## 1 Autonomo, freddo               90
## 2 Autonomo, freddo/caldo         63
## 3 <NA>                           61
## 4 Centralizzato, freddo/caldo    16
## 5 Autonomo                        7
## 6 Centralizzato, freddo           6
## 7 Predisposizione impianto        6
## 8 Centralizzato, caldo            1
```

What it can be seen form figure \@ref(fig:price_per_floor) Può, essere interessante guardare quali sono gli ultimi piani. 

<div class="figure">
<img src="07-exploratory_files/figure-html/price_per_floor-1.png" alt="Log Monthly Price per apt Floor?" width="672" />
<p class="caption">(\#fig:price_per_floor)Log Monthly Price per apt Floor?</p>
</div>
What it can be seen form figure \@ref(fig:price_per_totpiani) 

<div class="figure">
<img src="07-exploratory_files/figure-html/price_per_totpiani-1.png" alt="Log Monthly Price per building Height?" width="672" />
<p class="caption">(\#fig:price_per_totpiani)Log Monthly Price per building Height?</p>
</div>


<img src="07-exploratory_files/figure-html/unnamed-chunk-2-1.png" width="672" />

this visualization intersects allows to discover bimodality in the response variable.  Log scales was needed since they are all veru skewd and log scale then is needed also in the model.

(qui ci puoi mettere a confronto per variabile bianria, così vedi cosa includere nel modello esempio sotto dove commentato, )

<img src="07-exploratory_files/figure-html/unnamed-chunk-3-1.png" width="672" />

What it might be really relevant to research is how monthly prices change with respect to house squarefootage for each house configuration. The idea is to asses how much adding a further square meter affetcs the monthly price for each n-roomed flat.
One implication is how the property should be developed in order to request a greater amount of money per month. As an example in a situation in which the household has to lot its property into different sub units he can be helped to decide the most proficient choice in economic terms by setting ex ante the squarefootage extensions for each of the properties.
A further implication can regard economic choices to enlarge new property acquisitions under the expectation to broadened the squarefootage (contruction firms). Some of the choices have an economic sense, some of them have not.
The plot  \@ref(fig:glm_price_sq) has two contionous variables for x (price) and y (sqfootage) axis, the latter is log 10 scaled due to smoothness reasons. Coloration dicretizes points for the each $j$ household rooms totlocali. A sort of overlapping  piece-wise linear regression (log-linear due to transformation) is fitted on each totlocali group, whose response variable is price and whose only predictor is the squarefootage surface(i.e.  price ~ sqfeet). Five different regression models are displayed in the top left. The interesting part regards the models slopes $\hat\beta_{1,j}$. The highest corresponds to "Monolocale" for which the increment of a 10 square meter in surface enriches the apartement of a 1.1819524% monthly price addition. Almost the same is witnessed in "Bilocale" for which a 10 square meter enlargement gains 1.1194379%. One more major thing to notice is the "ensamble" regression line obtained as the interpolation of the plotted ones. The line suggests a clear descending pattern from Pentalocale and beyond whose assumption is strengthened by looking at the decreasing trend in the $\hat\beta_1$ predictor slopes coefficients.  

<img src="07-exploratory_files/figure-html/glm_price_sq-1.png" width="672" />

In table (...) are displayed the most valuable in absolute terms properties. The first 4 observations are "Bilocale" 

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> location </th>
   <th style="text-align:left;"> totlocali </th>
   <th style="text-align:right;"> price </th>
   <th style="text-align:right;"> sqfeet </th>
   <th style="text-align:left;"> floor </th>
   <th style="text-align:left;"> totpiani </th>
   <th style="text-align:right;"> abs_price </th>
   <th style="text-align:right;"> condom </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> viale cassiodoro 28 </td>
   <td style="text-align:left;"> Bilocale </td>
   <td style="text-align:right;"> 1750 </td>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:left;"> 9 piano </td>
   <td style="text-align:left;"> 10 piani </td>
   <td style="text-align:right;"> 58.33333 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> via della spiga 23 </td>
   <td style="text-align:left;"> Bilocale </td>
   <td style="text-align:right;"> 2750 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:left;"> 2 piano </td>
   <td style="text-align:left;"> 4 piani </td>
   <td style="text-align:right;"> 50.00000 </td>
   <td style="text-align:right;"> 250 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> corso giuseppe garibaldi 95 </td>
   <td style="text-align:left;"> Bilocale </td>
   <td style="text-align:right;"> 2700 </td>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:left;"> 2 piano </td>
   <td style="text-align:left;"> 5 piani </td>
   <td style="text-align:right;"> 48.21429 </td>
   <td style="text-align:right;"> 250 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> piazza san babila C.A. </td>
   <td style="text-align:left;"> Bilocale </td>
   <td style="text-align:right;"> 1833 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:left;"> 4 piano </td>
   <td style="text-align:left;"> 4 piani </td>
   <td style="text-align:right;"> 43.64286 </td>
   <td style="text-align:right;"> 192 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ottimo stato piano terra, C.A. </td>
   <td style="text-align:left;"> Trilocale </td>
   <td style="text-align:right;"> 3000 </td>
   <td style="text-align:right;"> 80 </td>
   <td style="text-align:left;"> Piano terra </td>
   <td style="text-align:left;"> 3 piani </td>
   <td style="text-align:right;"> 37.50000 </td>
   <td style="text-align:right;"> 250 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> via federico confalonieri 5 </td>
   <td style="text-align:left;"> Monolocale </td>
   <td style="text-align:right;"> 750 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> 1 piano </td>
   <td style="text-align:left;"> 3 piani </td>
   <td style="text-align:right;"> 37.50000 </td>
   <td style="text-align:right;"> 50 </td>
  </tr>
</tbody>
</table>

Then fitting a linear model can help to understand how covariates interact with response variable through coefficients interpretation. the The linear model fitted is `lm(log2(price_usd) ~ log2(volume_m3) + category + other_colors, data = .)`. 



## Missing Assessement and Imputation

As already pointed out some data went missing since immobiliare provides data that in turn is filled by estate agencies or privates through pre compiled standard formats. Some of the missing observations can be reverse engineered by other information in the web pages e.g. given the street address it is possible to trace back the lat and long coordinates, even though this is already handled by the API through scraping functions with the mechanism found in section \@ref(ContentArchitecture). Some of the information lacking in the summary table they might be desumed and then imputed by the estate agency review which is one of the covariates and where the most of the times missing information can be found. The approach followed in this part is to prune redundant information and "over" missing covariates trying to limit the dimensionality of the dataset.

### Missing assessement 

The first problem to assess is why information are missing. As already pointed out in the introduction part and in section \@ref(ContentArchitecture) many of the presumably important covariates (i.e. price lat, long, title ,id ...) undergo to a sequence of forced step inside scraping functions with the aim to avoid to be missed.  If in the end of the sequence the covariates values are still missing, the correspondent observation is not imputed and it is left out of the scraped dataset. The author choice to follow this approach relies on empirical observation that suggest when important information is missing then the rest of the covariates also do, as a consequence the observation is not useful. Moreover when the spatial component can no be reverse engineered then it is also the case of left out observation while scraping. The model needs to have a spatial component in order to be evaluted. To this purpose The missing profile is crucial since it can also suggest problems in the scraping procedure. By identifying pattern in missing observation the maintainer can take advantage of it and then debug the part that causes missingness. In order to identify the pattern a revision of missigness is introduced by @Little .randomnes can be devided into 3 categories:

- *MCAR* (missing completely at random) likelihood of missing is equal for all the infromation, in other words missing data are one idependetn for the other.
- *MAR* (missing at random) likelihood of missin is not equal.
- *NMAR* (not missing at random) data that is missing due to a specific cause, scarping can be the cause.

MNAR is often the case of daily monitoring clinical studies [@Kuhn2019], where patient might drop out the experiment because of death and so as a consequence all the data starting from the death time +1 is missing.
To assess pattern A _heat map_ plot fits the need: 

<div class="figure">
<img src="07-exploratory_files/figure-html/Heatmap-1.png" alt="Missingness Heatmap plot" width="672" />
<p class="caption">(\#fig:Heatmap)Missingness Heatmap plot</p>
</div>

Looking at the top of the heat map plot \@ref(fig:Heatmap) under the "Predictor" label the first tree split divides data into two sub-groups. The left branch considers from *TOTPIANI* to *CATASTINFO* and there are no substantial relevant worrying patterns.  Then missingness can be traced back to the MAR case. Imputation needs to be applied up to *CONDOM* included, the others are discarded due to rarity: i.e. *BUILDAGE*: 14% missing, *CATASTINFO*: 21% and *AC*: 24%. Moreover *CUCINA*,*ALTRO* are generated as separation of the original *LOCALI* variable, so it should not surprise that their missing behavior is similar which is respectively 13% and 14%, as a consequence  they are discarded. 
(capire se fare imputation per bagno cameraletto altro e cucina)
In the far right hand side *ENCLASS* and *DISP* data are completely missing, this can be addressed to a scraping fail to capture data. Further inspection of the API scraping process focused on the two covariates is strongly advised. From *LOWRDPRICE.* covariates class it seems to be witnessing a missing underlining pattern NMAR which is clearer by looking at the co_occurrence plot \@ref(fig:cooccurrence). Co-occurrence analysis might suggest frequency of missing predictor combinations and *LOWRDPRICE.* class covariates are displyaing this tyoe of behaviour. *PAUTO* is missing where lowered price class covariates are missing but this is not true for the contrary leading to the conclusion that *PAUTO* should be treated as a rare covariate, therefore *PAUTO* is discarded.
After a further investigation *LOWRDPRICE.* flags when the *PRICE* covariate is effectively decreased and this is not so common, that is solved by grouping the covariate's information and to encode it as a two levels categorical covariate. Further methods to feature engineer the lowrdprice. class covariates can be treated with profile data, but this is beyond the scope, further references are @Kuhn2019.

<div class="figure">
<img src="07-exploratory_files/figure-html/cooccurrence-1.png" alt="Missingness co-occurrence plot" width="672" />
<p class="caption">(\#fig:cooccurrence)Missingness co-occurrence plot</p>
</div>



### Covariates Imputation

A simple approach to front missing observations is to build a regression model to explain the covariates with the missing observations and plug-in the obtained estimates (e.g. posterior means) from their predictive distributions (Little and Rubin 2002). This approach is fast and easy to implement in most cases, but it ignores the uncertainty about the imputed values. However it has the benefit to be a reasonable choice with respect to the numbr of computation required. That makes it the first choice method to follow.
A further method for imputation has been designed by _Gómez-Rubio, Cameletti, and Blangiardo 2019) miss lit_ by adding a sub-model for the imputations to the final model through the inla functio. This is directly handled inside the predictor formula adding a parameter in the latent field. However the approach makes the model more complex with a further layer of uncertainty to handle. 
At first the additive regression model with all the covariates is called including the covariates with missing values. The response variable *PRICE* displys no missing values.




When the model is called INLA fit the model on the existing observations ignoring the missing ones. A summary of the model is now proposed. Once the model is trained then the posterior means can be imputed in the place where the respective covariates are missing. Then the model is called a second time to check changes in parameter estimates. The approach followed kindly differ from @Rubio2019 section 12.4 since response var in this case has not missing values, this should anyway give a better estimates since the model is trained on the whole set of the response variable observation. On the other hand, more than one covariates, the ones sentenced to be MAR, have missing values, therefore inla ultimately trains the model on the covariates' missing union set. e.g. missing observations CONDOM 240, missing in combination with other covariates.
0




## Spatial Autocorrelation assessement 




Spatial data come packed into point reference 

- tmap 
- leaflet 
- gganimate 



## Model Specification



## Mesh building 

*PARAFRASARE*
The SPDE approach approximates the continuous Gaussian field $w_{i}$ as a discrete Gaussian Markov random field by means of a finite basis function defined on a triangulated mesh of the region of study. The spatial surface can be interpolated performing this approximation with the inla.mesh.2d() function of the R-INLA package. This function creates a Constrained Refined Delaunay Triangulation (CRDT) over the study region, that will be simply referred to as the mesh. Mesh should be intended as a trade off between the accuracy of the GMRF surface representation and the computational cost, in other words the more are the vertices, the finer is the GF approximation, leading to a computational funnel. 

![Traingularization intuition, @Krainski-Rubio source](images/triangle.jpg)

Arguments can tune triangularization through inla.mesh.2d() :

* `loc`:location coordinates that are used as initial mesh vertices
* `boundary`:object describing the boundary of the domain,
* `offset`:  argument is a numeric value (or a length two vector) and it is used
to set the automatic extension distance. If positive, it is the extension distance
in the same scale units. If negative, it is interpreted as a factor relative to the
approximate data diameter; i.e., a value of -0.10 (the default) will add a 10%
of the data diameter as outer extension.
* `cutoff`: points at a closer distance than the supplied value are replaced by a single vertex. Hence, it avoids small triangles 
* `max.edge`: A good mesh needs to have triangles as regular as possible in size and shape.
* `min.angle`argument (which can be scalar or length two vector) can be used to specify the minimum internal angles of the triangles in the inner domain and the outer extension

A convex hull is a polygon of triangles out of the domain area, in other words the extension made to avoid the boundary effect. All meshes in Figure 2.12 have been made to have a convex hull boundary. If borders are available are generally preferred, so non convex hull meshes are avoided.



### Shinyapp for mesh assessment

INLA includes a Shiny (Chang et al., 2018) application that can be used to tune the mesh params interactively




The mesh builder has a number of options to define the mesh on the left side. These include options to be passed to functions inla.nonconvex.hull() and inla.mesh.2d() and the resulting mesh displayed on the right part.

### BUilding SPDE model on mesh




## Spatial Kriging (Prediction)

QUI INCERTEZZE









