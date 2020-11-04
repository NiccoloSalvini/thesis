# Exploratory Analysis {#exploratory}

<!--  You can label chapter and section titles using `{#label}` after them, e.g., we can reference Chapter \@ref(intro). If you do not manually label them, there will be automatic labels anyway, e.g., Chapter \@ref(methods).-->



Data comes packed into the REST API end point `*/complete` in .json format. Data can be filtered out On the basis of the options set in the API endpoint argument body. Some of the options might regard the `city` in which it is aevaluated the real estate market, `npages` as the number of pages to be scraped, `type` as the choice between rental of selling. For further documentation on how to structure the API endpoint query refer to section \@ref(APIdocs).  Since to the analysis purposes data should come from the same source (e.g. Milan rental real estate within "circonvallazione") a dedicated endpoint boolean option `.thesis` is passed in the argument body. What the API option under the hood is doing is specifying a structured and already filtered URL to be passed to the scraping endppoint. By securing the same URL to the scraping functions data is forced to come from the same URL source. The idea behind this concept can be thought as refreshing everyday the same immobiliare.it URL. API endpoint by default also specifies 10 pages to be scraped, in this case 120 is provided leading to to 3000 data points. The `*` refers to the EC2 public DNS that is `ec2-18-224-40-67.us-east-2.compute.amazonaws.com`

`http://*/complete/120/milano/affitto/.thesis=true`

As a further source data can also be accessed through the mondgoDB credentials with the cloud ATLAS database by picking up the latest .csv file generated. For run time reasons also related to the bookdown files continuous building the API endpoint is called the day before the presentation so that the latest .csv file is available. As a consequence code chunks outputs are all cached due to heavy computation.
Interactive  maps are done with Leaflet, the result of which is a leaflet map object which can be piped to other leaflet functions. This permits multiple map layers and many control options to be added interactively (LaTex output is statically generated)

A preliminary exploratory analysis evidences 34 covariates and 250 rows. Immobiliare.it furnishes many information regarding property attributes and estate agency circumstances. Data displays many NA in some of the columns but georeference coordinates, due to the design of scraping functions, are in any case present. 

<table class="table" style="font-size: 8px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> name </th>
   <th style="text-align:left;"> ref </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;"> ID </td>
   <td style="text-align:left;width: 20em; "> ID of the apartements </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> LAT </td>
   <td style="text-align:left;width: 20em; "> latitude coordinate </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> LONG </td>
   <td style="text-align:left;width: 20em; "> longitude coordinate </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> LOCATION </td>
   <td style="text-align:left;width: 20em; "> the complete address: street name and number </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> CONDOM </td>
   <td style="text-align:left;width: 20em; "> the condominium monthly expenses </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> BUILDAGE </td>
   <td style="text-align:left;width: 20em; "> the age in which the building was contructed </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> FLOOR </td>
   <td style="text-align:left;width: 20em; "> the floor the apartement is </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> INDIVSAPT </td>
   <td style="text-align:left;width: 20em; "> indipendent propeorty versus apartement </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> LOCALI </td>
   <td style="text-align:left;width: 20em; "> specification of the type and number of rooms </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> TPPROP </td>
   <td style="text-align:left;width: 20em; "> property type residential or not </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> STATUS </td>
   <td style="text-align:left;width: 20em; "> the actual status of the house, ristrutturato, nuovo, abitabile </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> HEATING </td>
   <td style="text-align:left;width: 20em; "> the heating system centralized or autonomous </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> AC </td>
   <td style="text-align:left;width: 20em; "> air conditioning hot and cold </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> PUB_DATE </td>
   <td style="text-align:left;width: 20em; "> the date of publication of the advertisement </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> CATASTINFO </td>
   <td style="text-align:left;width: 20em; "> land registry infromation </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> APTCHAR </td>
   <td style="text-align:left;width: 20em; "> apartement main characteristics </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> PHOTOSNUM </td>
   <td style="text-align:left;width: 20em; "> number of photos displayes </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> AGE </td>
   <td style="text-align:left;width: 20em; "> estate agency name </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> LOWRDPRICE.originalPrice </td>
   <td style="text-align:left;width: 20em; "> If the price is lowered it indicates the starting price </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;"> LOWRDPRICE.currentPrice </td>
   <td style="text-align:left;width: 20em; "> If the price is lowered it indicates the current price </td>
  </tr>
</tbody>
</table>

Geographic coordinates can be represented on a map in order to get a first perception of spatial autocorrelations clusters.
Leaflet maps are created with leaflet(), the result of which is a leaflet map object which can be piped to other leaflet functions. This allows multiple map layers and control settings to be added interactivelyleaflet object takes as input data in latitude and longitude UTM coordinates so no transfomation is required. Otherwise a projection to the right zone would be required and the a sp transform 

<!--html_preserve--><div id="htmlwidget-ba65adcb26707f85bf7e" style="width:100%;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-ba65adcb26707f85bf7e">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"setView":[[45.474211,9.191383],13,[]],"calls":[{"method":"addMiniMap","args":[null,null,"bottomright",150,150,19,19,-5,false,false,false,false,false,false,{"color":"#ff7800","weight":1,"clickable":false},{"color":"#000000","weight":1,"clickable":false,"opacity":0,"fillOpacity":0},{"hideText":"Hide MiniMap","showText":"Show MiniMap"},[]]},{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircles","args":[[45.477,45.4709,45.4605,45.4709,45.4709,45.476,45.4753,45.4694,45.4813,45.4771,45.4534,45.4612,45.4969,45.4919,45.4825,45.4513,45.4495,45.4732,45.4632,45.4657,45.4481,45.4444,45.4555,45.4794,45.4659,45.4694,45.4706,45.4877,45.4815,45.4824,45.4781,45.4488,45.4668,45.4593,45.4731,45.4813,45.4771,45.4805,45.471,45.4705,45.49,45.4566,45.4608,45.4439,45.4921,45.4705,45.4528,45.4795,45.4733,45.4596,45.4616,45.4699,45.4568,45.49,45.4826,45.4747,45.4567,45.4569,45.4759,45.4863,45.4777,45.4712,45.4604,45.4647,45.4917,45.4746,45.4717,45.4618,45.4836,45.4656,45.4642,45.452,45.4725,45.4833,45.4573,45.4477,45.4865,45.4729,45.4789,45.455,45.4669,45.4515,45.4699,45.4683,45.4914,45.4809,45.4648,45.4797,45.4583,45.4631,45.4592,45.4547,45.4568,45.4693,45.4583,45.4747,45.4567,45.4616,45.472,45.4823,45.4615,45.4726,45.4801,45.4626,45.4621,45.4684,45.4778,45.4805,45.4529,45.4847,45.4597,45.4631,45.4467,45.459,45.4897,45.4551,45.4472,45.4472,45.4657,45.4467,45.4779,45.4897,45.4468,45.4722,45.4726,45.4865,45.4761,45.4656,45.4701,45.4701,45.4467,45.4707,45.4584,45.4567,45.4773,45.4659,45.4856,45.4513,45.4668,45.4584,45.4812,45.4628,45.4511,45.4774,45.487,45.4769,45.4482,45.4643,45.4843,45.4879,45.4897,45.4621,45.4878,45.477,45.4876,45.4842,45.488,45.4793,45.4548,45.4668,45.4654,45.4702,45.4819,45.4432,45.4668,45.4657,45.4747,45.4674,45.4897,45.4714,45.478,45.4662,45.4729,45.4783,45.4666,45.4572,45.4709,45.4656,45.4859,45.474,45.4879,45.48,45.4909,45.4787,45.4909,45.4651,45.4674,45.4581,45.4583,45.4461,45.4659,45.4715,45.4558,45.4669,45.4634,45.4512,45.4574,45.4857,45.4639,45.4554,45.4514,45.4593,45.4723,45.4733,45.4797,45.476,45.4815,45.4464,45.4737,45.4797,45.4878,45.4887,45.4863,45.4734,45.4812,45.49,45.4739,45.4729,45.4449,45.4814,45.456,45.467,45.4544,45.4677,45.4863,45.4713,45.4547,45.4452,45.4705,45.4897,45.4895,45.5036,45.4564,45.4726,45.4583,45.4681,45.4671,45.4664,45.4701,45.4791,45.4779,45.4708,45.459,45.4878,45.4748,45.4732,45.4725,45.4785,45.4765,45.471],[9.15101,9.20868,9.18927,9.20868,9.20868,9.2116,9.205,9.1583,9.1884,9.20441,9.2193,9.2035,9.1853,9.2077,9.1736,9.1852,9.1996,9.2063,9.22367,9.1708,9.1769,9.1764,9.1875,9.1877,9.2064,9.2186,9.1517,9.2027,9.2102,9.1851,9.1899,9.1617,9.2159,9.2071,9.1887,9.1792,9.1842,9.2126,9.1876,9.1963,9.2191,9.207,9.2307,9.1802,9.1861,9.2035,9.19494,9.216,9.2144,9.1797,9.19053,9.1867,9.2147,9.1645,9.2005,9.1834,9.1873,9.2143,9.1708,9.2336,9.17866,9.19181,9.1765,9.1664,9.2184,9.2221,9.2035,9.2144,9.1677,9.152,9.1988,9.1783,9.1886,9.17095,9.1805,9.159,9.188,9.2133,9.1785,9.1668,9.1973,9.156,9.18366,9.16652,9.18645,9.1998,9.1566,9.2195,9.2071,9.1988,9.2008,9.17209,9.21036,9.19777,9.1541,9.18837,9.1749,9.2213,9.23739,9.22107,9.1552,9.1859,9.2031,9.2,9.2098,9.1776,9.188,9.192,9.1663,9.1626,9.207,9.1808,9.18773,9.2139,9.2059,9.2001,9.1981,9.1789,9.2307,9.19687,9.211,9.203,9.1656,9.21577,9.1924,9.1901,9.2242,9.2055,9.19498,9.1905,9.1637,9.20858,9.1859,9.1873,9.2103,9.21327,9.1976,9.17325,9.156,9.1809,9.2253,9.1812,9.19242,9.2159,9.1568,9.2169,9.1886,9.1794,9.1636,9.187,9.1831,9.2034,9.22375,9.15101,9.1861,9.17174,9.18815,9.18943,9.18425,9.22555,9.21241,9.16526,9.1558,9.21717,9.1505,9.20925,9.20954,9.1523,9.22575,9.2005,9.18341,9.18085,9.1872,9.2192,9.16,9.17552,9.148,9.18,9.1536,9.182,9.1854,9.1659,9.1864,9.1612,9.1864,9.20754,9.15785,9.1611,9.2076,9.1787,9.1836,9.19277,9.1536,9.18362,9.2096,9.177,9.17329,9.1523,9.1809,9.17614,9.2009,9.1726,9.1969,9.1878,9.1606,9.2103,9.21866,9.177,9.2091,9.1933,9.15496,9.2256,9.1601,9.15177,9.17738,9.20619,9.19306,9.1847,9.1792,9.2058,9.19941,9.18167,9.1738,9.16242,9.156,9.1842,9.18042,9.1721,9.1841,9.1486,9.1675,9.1932,9.2119,9.1924,9.1523,9.1919,9.2018,9.15971,9.197,9.18407,9.17939,9.21233,9.1803,9.1913,9.1442,9.21961,9.2279,9.2225,9.1603,9.1876],[7.80384330353877,7.09007683577609,8.00636756765025,7.17011954344963,7.43838353004431,8.25582842728183,8.51719319141624,7.97796809312855,7.97246601597457,7.09007683577609,6.39692965521615,8.1605182474775,6.90775527898214,7.27931883541462,6.95654544315157,7.22620901010067,6.62007320653036,7.97246601597457,6.95654544315157,7.3132203870903,6.90775527898214,7.00306545878646,7.52294091807237,6.95654544315157,7.3132203870903,7.71868549519847,7.3132203870903,7.09007683577609,6.69703424766648,6.80239476332431,7.60090245954208,7.09007683577609,7.09007683577609,6.75693238924755,7.69621263934641,7.43838353004431,7.90100705199242,7.43838353004431,7.82404601085629,7.91935619066062,6.80239476332431,7.20785987143248,6.86484777797086,6.47697236288968,7.09007683577609,8.20685642839965,8.1605182474775,7.00306545878646,7.09007683577609,7.00306545878646,7.34601020991329,7.54960916515453,6.74523634948436,7.3132203870903,7.54960916515453,7.60090245954208,7.43838353004431,7.24422751560335,7.26542972325395,7.37775890822787,6.68461172766793,8.1605182474775,7.0475172213573,7.90100705199242,6.7093043402583,7.60090245954208,8.00636756765025,7.00306545878646,7.27239839257005,6.84587987526405,7.00306545878646,8.00636756765025,8.00636756765025,6.80239476332431,6.8351845861473,6.85646198459459,6.5510803350434,7.09007683577609,7.0475172213573,6.85646198459459,7.5137092478397,7.09007683577609,7.43838353004431,7.17011954344963,7.00306545878646,7.82404601085629,7.54960916515453,7.54960916515453,7.3132203870903,8.1605182474775,7.20785987143248,7.60090245954208,7.0343879299155,7.68017564043659,6.80239476332431,7.60090245954208,7.13089883029635,7.82404601085629,6.85646198459459,6.30991827822652,7.3132203870903,8.00636756765025,7.17011954344963,7.87283617502572,6.74523634948436,8.00636756765025,7.69621263934641,7.9373746961633,7.24422751560335,7.24422751560335,6.5510803350434,8.06148686687133,7.13089883029635,7.24422751560335,6.47697236288968,6.74523634948436,7.24422751560335,7.37775890822787,6.74523634948436,7.43838353004431,7.3132203870903,7.60090245954208,6.68461172766793,7.69621263934641,8.07090608878782,6.62007320653036,7.17011954344963,7.52294091807237,8.33086361322474,8.41183267575841,7.09007683577609,7.43838353004431,7.07326971745971,7.3132203870903,6.85646198459459,7.60090245954208,7.20785987143248,6.90775527898214,7.20785987143248,6.86693328446188,7.37775890822787,8.85366542803745,6.80239476332431,7.00306545878646,6.39692965521615,6.68461172766793,7.00306545878646,8.1605182474775,7.09007683577609,6.80239476332431,6.85646198459459,7.52294091807237,6.94697599213542,7.54960916515453,7.13089883029635,7.17011954344963,6.74523634948436,7.60090245954208,6.74523634948436,7.43248380791712,7.09007683577609,7.7621706071382,6.90775527898214,7.17011954344963,7.20785987143248,6.90775527898214,7.09007683577609,7.00306545878646,6.50279004591562,8.20658361432075,8.10167774745457,7.60090245954208,7.40853056689463,7.99967857949945,7.09007683577609,7.34601020991329,7.3132203870903,7.40853056689463,7.00306545878646,7.34601020991329,6.85646198459459,7.62559507213245,7.27931883541462,6.85646198459459,6.47697236288968,7.24422751560335,7.3132203870903,7.20785987143248,6.90775527898214,7.40853056689463,7.09007683577609,8.80986280537906,7.43838353004431,8.1605182474775,6.85646198459459,6.80239476332431,7.69621263934641,7.24422751560335,8.74033674273045,7.17011954344963,6.68461172766793,7.60090245954208,7.37462901521894,7.29979736675816,7.34601020991329,7.39326309476384,6.47697236288968,7.13886699994552,6.80239476332431,8.26873183211774,6.80239476332431,7.3132203870903,7.03878354138854,7.24422751560335,6.47697236288968,6.5510803350434,8.69951474821019,8.00636756765025,6.39692965521615,6.90775527898214,6.90775527898214,7.60090245954208,6.80239476332431,6.74523634948436,6.80239476332431,7.78322401633604,7.17011954344963,7.17011954344963,8.33495163142245,6.85646198459459,6.77992190747225,6.68461172766793,7.24422751560335,8.1605182474775,7.13089883029635,8.59415423255237,7.82404601085629,7.40853056689463,7.41878088275079,7.9373746961633,7.00306545878646,8.29404964010203,7.60090245954208,8.29404964010203,7.34601020991329,7.34601020991329,7.09007683577609,7.74066440191724,7.46737106691756,7.62559507213245],null,null,{"interactive":true,"className":"","stroke":true,"color":["#35B779","#440154","#FDE725","#440154","#31688E","#FDE725","#FDE725","#FDE725","#FDE725","#440154","#808080","#FDE725","#440154","#440154","#440154","#440154","#808080","#FDE725","#440154","#31688E","#440154","#440154","#31688E","#440154","#31688E","#35B779","#31688E","#440154","#808080","#808080","#35B779","#440154","#440154","#808080","#35B779","#31688E","#FDE725","#31688E","#FDE725","#FDE725","#808080","#440154","#808080","#808080","#440154","#FDE725","#FDE725","#440154","#440154","#440154","#31688E","#31688E","#808080","#31688E","#31688E","#35B779","#31688E","#440154","#440154","#31688E","#808080","#FDE725","#440154","#FDE725","#808080","#35B779","#FDE725","#440154","#440154","#808080","#440154","#FDE725","#FDE725","#808080","#808080","#808080","#808080","#440154","#440154","#808080","#31688E","#440154","#31688E","#440154","#440154","#FDE725","#31688E","#31688E","#31688E","#FDE725","#440154","#35B779","#440154","#35B779","#808080","#35B779","#440154","#FDE725","#808080","#808080","#31688E","#FDE725","#440154","#FDE725","#808080","#FDE725","#35B779","#FDE725","#440154","#440154","#808080","#FDE725","#440154","#440154","#808080","#808080","#440154","#31688E","#808080","#31688E","#31688E","#35B779","#808080","#35B779","#FDE725","#808080","#440154","#31688E","#FDE725","#FDE725","#440154","#31688E","#440154","#31688E","#808080","#35B779","#440154","#440154","#440154","#808080","#31688E","#808080","#808080","#440154","#808080","#808080","#440154","#FDE725","#440154","#808080","#808080","#31688E","#440154","#31688E","#440154","#440154","#808080","#35B779","#808080","#31688E","#440154","#35B779","#440154","#440154","#440154","#440154","#440154","#440154","#808080","#FDE725","#FDE725","#35B779","#31688E","#FDE725","#440154","#31688E","#31688E","#31688E","#440154","#31688E","#808080","#35B779","#440154","#808080","#808080","#440154","#31688E","#440154","#440154","#31688E","#440154","#808080","#31688E","#FDE725","#808080","#808080","#35B779","#440154","#808080","#440154","#808080","#35B779","#31688E","#440154","#31688E","#31688E","#808080","#440154","#808080","#FDE725","#808080","#31688E","#440154","#440154","#808080","#808080","#808080","#FDE725","#808080","#440154","#440154","#35B779","#808080","#808080","#808080","#35B779","#440154","#440154","#FDE725","#808080","#808080","#808080","#440154","#FDE725","#440154","#808080","#FDE725","#31688E","#31688E","#FDE725","#440154","#FDE725","#35B779","#FDE725","#31688E","#31688E","#440154","#35B779","#31688E","#35B779"],"weight":10,"opacity":0.5,"fill":true,"fillColor":["#35B779","#440154","#FDE725","#440154","#31688E","#FDE725","#FDE725","#FDE725","#FDE725","#440154","#808080","#FDE725","#440154","#440154","#440154","#440154","#808080","#FDE725","#440154","#31688E","#440154","#440154","#31688E","#440154","#31688E","#35B779","#31688E","#440154","#808080","#808080","#35B779","#440154","#440154","#808080","#35B779","#31688E","#FDE725","#31688E","#FDE725","#FDE725","#808080","#440154","#808080","#808080","#440154","#FDE725","#FDE725","#440154","#440154","#440154","#31688E","#31688E","#808080","#31688E","#31688E","#35B779","#31688E","#440154","#440154","#31688E","#808080","#FDE725","#440154","#FDE725","#808080","#35B779","#FDE725","#440154","#440154","#808080","#440154","#FDE725","#FDE725","#808080","#808080","#808080","#808080","#440154","#440154","#808080","#31688E","#440154","#31688E","#440154","#440154","#FDE725","#31688E","#31688E","#31688E","#FDE725","#440154","#35B779","#440154","#35B779","#808080","#35B779","#440154","#FDE725","#808080","#808080","#31688E","#FDE725","#440154","#FDE725","#808080","#FDE725","#35B779","#FDE725","#440154","#440154","#808080","#FDE725","#440154","#440154","#808080","#808080","#440154","#31688E","#808080","#31688E","#31688E","#35B779","#808080","#35B779","#FDE725","#808080","#440154","#31688E","#FDE725","#FDE725","#440154","#31688E","#440154","#31688E","#808080","#35B779","#440154","#440154","#440154","#808080","#31688E","#808080","#808080","#440154","#808080","#808080","#440154","#FDE725","#440154","#808080","#808080","#31688E","#440154","#31688E","#440154","#440154","#808080","#35B779","#808080","#31688E","#440154","#35B779","#440154","#440154","#440154","#440154","#440154","#440154","#808080","#FDE725","#FDE725","#35B779","#31688E","#FDE725","#440154","#31688E","#31688E","#31688E","#440154","#31688E","#808080","#35B779","#440154","#808080","#808080","#440154","#31688E","#440154","#440154","#31688E","#440154","#808080","#31688E","#FDE725","#808080","#808080","#35B779","#440154","#808080","#440154","#808080","#35B779","#31688E","#440154","#31688E","#31688E","#808080","#440154","#808080","#FDE725","#808080","#31688E","#440154","#440154","#808080","#808080","#808080","#FDE725","#808080","#440154","#440154","#35B779","#808080","#808080","#808080","#35B779","#440154","#440154","#FDE725","#808080","#808080","#808080","#440154","#FDE725","#440154","#808080","#FDE725","#31688E","#31688E","#FDE725","#440154","#FDE725","#35B779","#FDE725","#31688E","#31688E","#440154","#35B779","#31688E","#35B779"],"fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]},{"method":"addLegend","args":[{"colors":["#440154","#31688E","#35B779","#FDE725"],"labels":["1,000 &ndash; 1,500","1,500 &ndash; 2,000","2,000 &ndash; 2,500","2,500 &ndash; 5,000"],"na_color":null,"na_label":"NA","opacity":0.5,"position":"bottomright","type":"bin","title":"Prices","extra":null,"layerId":null,"className":"info legend","group":null}]},{"method":"addScaleBar","args":[{"maxWidth":100,"metric":true,"imperial":true,"updateWhenIdle":true,"position":"bottomleft"}]}],"limits":{"lat":[45.4432,45.5036],"lng":[9.1442,9.23739]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


##  Data preparation 

As already pointed out some data went missing since immobiliare provides data that in turn is filled by estate agencies or privates through pre compiled standard formats. Some of the missing observations can be reverse engineered by other information in the web pages e.g. given the street address it is possible to trace back the lat and long coordinates, even though this is already handled by the API through scraping functions with the mechanism found in section \@ref(ContentArchitecture). Some of the information lacking in the summary table they might be desumed and then imputed by the estate agency review which is one of the covariates and where the most of the times missing information can be found. The approach followed in this part is to prune redundant information and "over" missing covariates trying to limit the dimensionality of the dataset.


### NA Removal and Imputation 

The first problem to assess is why information are missing. As already pointed out in the introduction part and in section \@ref(ContentArchitecture) many of the presumably important covariates (i.e. price lat, long, title ,id ...) undergo to a sequence of forced step inside scraping functions with the aim to avoid to be missed.  If in the end of the sequence the covariates values are still missing, the correspondent observation is not imputed and it is left out of the scraped dataset. The author choice to follow this approach relies on empirical observation that suggest when important inframtion is missing then the rest of the covariates also do, as a consequence the observation is not useful. Moreover when the spatial component can no be reverse engineered then it is also the case of left out observation while scraping. The model needs to have a spatial component in order to be evaluted. To this purpose The missing profile is crucial since it can also suggest problems in the scraping procedure. By identifying pattern in missing observation the maintainer can take advanatge of it and then debug the part that causes missingness. In order to identify the pattern a revision of missigness is introduced by _Little and Rubin (2014) miss lit_ .randomnes can be devided into 3 categories:

- MCAR (missing completely at random) likelihood of missing is equal for all the infromation, in other words missing data are one idependetn for the other.
- MAR (missing at random) likelihood of missin is not equal.
- *NMAR* (not missing at random) data that is missing due to a specific cause, scarping can be the cause.

The last iphothesis MNAR is often the case of daily monitoring clinical studies, where patient might drop out the experiment because of death and so as a consequence all the data starting from the death time +1 is missing.
To assess pattern A _heat map_ plot fits the need: 

<div class="figure">
<img src="07-exploratory_files/figure-html/Heatmap-1.png" alt="Missingness Heatmap plot" width="672" />
<p class="caption">(\#fig:Heatmap)Missingness Heatmap plot</p>
</div>

<div class="figure">
<img src="07-exploratory_files/figure-html/cooccurrence-1.png" alt="Missingness co-occurrence plot" width="672" />
<p class="caption">(\#fig:cooccurrence)Missingness co-occurrence plot</p>
</div>

Looking at the left hand of the heat map plot \@ref(fig:Heatmap) from *TOTPIANI* to *AC* there are no relevant patterns and missingness can be traced back to MAR, conditioned mean imputation is applied. In the far right hand side *ENCLASS* and *DISP* data is completely missing, this can be addressed to a scraping fail. Further inspection of the API scraping process focused on those covariates is strongly advised. From *LOWRDPRICE.* covariates class it seems to be witnessing a missing underlining pattern NMAR which is clearer by looking are the second co_occurrence plot \@ref(fig:cooccurrence) analysis. Co-occurrence analysis might suggest frequency of missing predictor combinations and *LOWRDPRICE.* class covariates are missing all together in combination. *PAUTO* is missing where lowered price class covariates are missing but this is not true for all the observations leading to the conclusion that pauto should be treated as a low prevalence covariate, therefore PAUTO is discarded.
After a further investigation *LOWRDPRICE.* exists when the price covariates is effectively decreased, that leads to group the covariate's information and to encode it as a two levels categorical covariate. Further methods to feature engineer the lowrdprice covariates are profile data. 


## Spatial Autocorrelation assessement 

- tmap 
- leaflet 
- gganimate 



## Model Specification 


## Mesh building 


### BUilding SPDE model on mesh


## Spatial Kriging (Prediction)











