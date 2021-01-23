# Exploratory Analysis {#exploratory}

<!--  You can label chapter and section titles using `{#label}` after them, e.g., we can reference Chapter \@ref(intro). If you do not manually label them, there will be automatic labels anyway, e.g., Chapter \@ref(methods).-->




Data emerging from the RESTful API body response is not in its tidiest format regardless of the query arguments sent. Yet data undergoes to a series of pre-processing step during scraping, which still requires to clear up unnecessary character and to separate columns containing more than one covariate. To the analysis extent data should be reproducible in the sense that it should be constrained to the same geographic area otherwise the analysis would not be either comparable nor reproducible. As a result RESTful API parameters calls are kept permanent by passing to the API the `.thesis` parameter, section \@ref(docs). In other words the (mandatory) argument option secures to specify to the API an already composed url to be passed to the scraping endpoint. The composed url corresponds to the properties contained in zones within the _Municipality of Milan_ borders. From a more practical point of view the operation is the equivalent to refresh each time the same immobiliare.it web page for which filters are always the same. A further parameter npages is set equal to 10, leading to to a total of 250 data points.
<!-- As a further data source is available a mondgoDB ATLAS cluster which, because of the scheduler, stocks daily .csv information from Milan real estate. Credentials have to be supplied. For run time reasons also related to the bookdown files continuous building the API endpoint is not called and code chunks outputs are cached due to heavy computation. Instead data is extracted from the MongoDB cluster.  -->
A summary table of the columns involved in the analysis is presented with the goal to familiarize with incoming API data. Data already enters semi-preprocessed, but due to API smoothness reasons it still needs some processing, treated in\@ref(prep). Data gathered from the second /completescrape endpoint contains geo-statistical components and consequently a map representation of Real Estate rental maket at the gitbook building time  i.e. (2021-01-21 ) is given. A further plot assess spatial dependence highlighting that coordinates are non-linearly related \@ref(fig:NonLinearSpatialRel) to the y-response monthlyprice variable. Exploration starts with factor counts evidencing a "Bilocale" prevalence. This implies some critical Milan real estate market demand information and consequently reflections on the offer. Data displays bimodality in prices distribution for different n-roomed accommodations and the model should take account of the behavior. Then a piece-wise linear regression is fitted for each household type accommodation factor, whose single predictor is the square meter footage. The analysis emphasize some valuable economic consequences both for investors interested into property expansions and for tenants that are planning to partition single properties into rentable sub-units. The previous analysis brings along a major question which addresses the most valuable properties per single square meter surface and an answer based on data is given. Then a log-linear model is fitted on some presumably important covariates to evaluate each single house characteristic contribution to the price. A Tie Fighter plot displays for which coefficient, associated to each dummy predictor, surprisingly high monthly prices compared to the effect of the square meter footage expansion. A partial conclusion is that disposing of 2 or 3 bathrooms truly pays back an extra monthly return, also due to the number of tentants the accomodations could host. Text mining techniques are applied on real estate agency reviews and a network graph can help to distinguish topics. Then Missing assessement and imputation takes place. At first is made a brief a revision on randomness in missing by @Little which may help to figure out if data is missing due to API failures or for other reasons. Theory is applied by visualizing missingness in combination with heat-map and co-occurrence plot. Combined missing observation test is able to detect whether data is missing because of inner scraping faiilures or simple low prevalence in appereance. Then for each of the covariate that pass the exam, then imputation is made through INLA posterior expectation. This is the case of missing data in predictors, so the missing covariates ( _condominium_ ) are brought into a model as response variable where this time predictors are the explanatory ones. Through a method specified within the INLA function the posterior statistics are computed and then finally imputed in the place of missing ones.

<!-- Visualisations are done with ggplot2 in a Tidyverse approach. Maps are done with ggplot2 too and Leaflet, together with its extensions.  -->
<!-- A preliminary API data exploratory analysis evidences 34 covariates and 250 rows, which are once again conditioned to the query sent to the API. Immobiliare.it furnishes many information regarding property attributes and estate agency circumstances. Data displays many NA in some of the columns but georeference coordinates, due to the design of scraping functions, are in any case present.  -->





**prova a farla in latex e aggiungere covariate nuove su dataset più grande***

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
   <td style="text-align:left;"> LOWRDPRICE_ORIGINAL_PRICE </td>
   <td style="text-align:left;"> If the price is lowered it flags the starting price </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOWRDPRICE_CURRENT_PRICE </td>
   <td style="text-align:left;"> If the price is lowered it flags the current price </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOWRDPRICE_PASSED_DAYS </td>
   <td style="text-align:left;"> If the price is lowered indicates the days passed since the price has changed </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LOWRDPRICE_DATE </td>
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


## Data Preprocessing{#prep}

Data needs to undergo to many previous cleaning preprocess steps, which mainly regard separating columns and extracting relevant covariates. This is a forced stage since for the way the API is designed it tries several searches (refer to fig. \@ref(fig:pseudocode1)) for the data demanded. Chances are that information may be found into a hidden json object (this is true fot Latitude and Longitude) which needs some heavy wrangling. Steps followed are:

- *floors* covariate needs to be separated in its *ascensore* and *accdisabili* components, adding 2 more bivariate covariates.
- *locali* needs to be separated too. 5 category levels drain out: *totlocali*, *camereletto*, *altro*, *bagno*, *cucina*. *nroom* is a duplicate for *totlocali*, so it is discarded.
- *aptchar* is a character string column that contains a non fixed number of features per house. The preprocess steps include cleaning the string from unnecessary characters, finding the set of unique elements across the character column (regex pattern), separating each feature in its proper column, in the end recoding newly created bivariate columns as "yes" or "no" according to a matching pattern.

## Maps and Geo-Visualisations

Geographic coordinates can be represented on a map in order to reveal first symptoms of spatial autocorrelation. Observations are spread almost equally throughout the surface even though the response *price* indicates unsurprisingly that higher prices are located near to the city center.
The map in figure \@ref(fig:leaflet_visuals) is a leaflet object, which needs to be overlapped with layers indicating different maps projections. This is interactive in the .html version, and static is proposed in the .pdf output version. The map object takes a input the latitute and longitude coordinates coming from THE API, and they do not need any CRS (Coordinate Reference System) projection since leaflet can accept the data type.

<!--html_preserve--><div id="htmlwidget-ed82f9c30c1edb7e97d3" style="width:100%;height:400px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-ed82f9c30c1edb7e97d3">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addSelect","args":["houses"]},{"method":"addMiniMap","args":[null,null,"bottomright",150,150,19,19,-5,false,false,false,false,false,false,{"color":"#ff7800","weight":1,"clickable":false},{"color":"#000000","weight":1,"clickable":false,"opacity":0,"fillOpacity":0},{"hideText":"Hide MiniMap","showText":"Show MiniMap"},[]]},{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircles","args":[[45.4605,45.4848,45.4709,45.4749,45.4528,45.4762,45.4575,45.4609,45.4789,45.4812,45.4634,45.4705,45.4555,45.4705,45.49,45.4733,45.49,45.4675,45.4501,45.508,45.4821,45.4401,45.4842,45.472,45.4623,45.4834,45.4693,45.4771,45.4708,45.4396,45.5005,45.5005,45.4745,45.4708,45.4655,45.4628,45.4662,45.4457,45.4657,45.4715,45.4705,45.48,45.4699,45.4389,45.4719,45.4778,45.4662,45.4781,45.4783,45.4454,45.4684,45.4646,45.5101,45.4646,45.4402,45.484,45.4635,45.4606,45.4388,45.4415,45.4712,45.4613,45.4877,45.483,45.4717,45.452,45.4541,45.4769,45.4494,45.4822,45.4825,45.4766,45.4835,45.4531,45.5036,45.4893,45.4642,45.4544,45.5018,45.4568,45.4739,45.4604,45.4725,45.4676,45.4455,45.4439,45.465,45.4935,45.5162,45.4634,45.453,45.4679,45.4469,45.4737,45.4839,45.452,45.5002,45.4811,45.4646,45.4505,45.4462,45.4826,45.4502,45.5162,45.4485,45.4419,45.4873,45.4725,45.4635,45.4485,45.4678,45.4535,45.4958,45.5276,45.4643,45.5066,45.4541,45.4597,45.4572,45.4669,45.4689,45.4712,45.4678,45.4711,45.4678,45.4597,45.4648,45.4648,45.4712,45.4686,45.4386,45.4648,45.4592,45.4631,45.4625,45.4508,45.4504,45.4508,45.4498,45.4419,45.4608,45.5079,45.4684,45.4657,45.4888,45.4515,45.4645,45.4788,45.457,45.4596,45.4508,45.4915,45.4701,45.4923,45.4572,45.4557,45.4557,45.469,45.4389,45.4639,45.4764,45.4725,45.483,45.4738,45.4786,45.474,45.4554,45.4748,45.4547,45.4838,45.4885,45.4561,45.4522,45.4794,45.4467,45.4897,45.4807,45.4493,45.4679,45.4634,45.4552,45.4705,45.4801,45.4659,45.4659,45.4488,45.4691,45.4662,45.4701,45.4361,45.467,45.4653,45.4586,45.4659,45.4686,45.4705,45.4581,45.5063,45.4617,45.4903,45.471,45.491,45.4475,45.4373,45.4588,45.4828,45.4812,45.4777,45.4648,45.4528,45.4721,45.4746,45.4704,45.4797,45.469,45.4604,45.4551,45.4512,45.4889,45.4854,45.4749,45.4879,45.4751,45.4496,45.4723,45.4686,45.4784,45.4767,45.4785,45.4817,45.4513,45.4515,45.4905,45.4638,45.4763,45.4638,45.4702,45.4747,45.4929,45.4672,45.4949,45.4862,45.4701,45.499,45.4659,45.5014,45.4627,45.4521,45.4627,45.4573],[9.18942,9.1713,9.2087,9.1869,9.2041,9.2037,9.2161,9.1831,9.1761,9.1983,9.1387,9.2035,9.1875,9.2035,9.2196,9.1576,9.2191,9.2144,9.221,9.2471,9.1873,9.1965,9.11509,9.2033,9.1378,9.1631,9.15563,9.1842,9.1686,9.2169,9.2005,9.2005,9.2042,9.1686,9.1636,9.1718,9.1768,9.1643,9.19904,9.1928,9.1963,9.2154,9.216,9.1994,9.2052,9.2147,9.1768,9.1899,9.1705,9.164,9.1727,9.1763,9.245,9.1596,9.1842,9.1822,9.1818,9.1854,9.1491,9.2,9.1629,9.18,9.2027,9.1657,9.2035,9.2052,9.1886,9.1977,9.1995,9.218,9.1878,9.1857,9.2077,9.1705,9.1624,9.1918,9.1988,9.1603,9.1465,9.2147,9.2124,9.1765,9.1886,9.15424,9.17676,9.1523,9.2064,9.1914,9.1698,9.1841,9.2041,9.1833,9.1507,9.2288,9.1837,9.1783,9.2118,9.2412,9.1981,9.1821,9.1954,9.2068,9.1937,9.1698,9.2203,9.2199,9.1692,9.2465,9.2026,9.1959,9.1627,9.157,9.17184,9.1783,9.1878,9.244,9.1729,9.207,9.1681,9.1973,9.2149,9.1524,9.2088,9.1851,9.1622,9.207,9.1964,9.1964,9.194,9.1989,9.1965,9.1964,9.2008,9.1988,9.2295,9.21278,9.21232,9.21278,9.21176,9.1817,9.2307,9.20807,9.1776,9.18233,9.19407,9.1897,9.1701,9.2065,9.1606,9.1853,9.21278,9.1622,9.19498,9.2332,9.2167,9.2155,9.2139,9.1628,9.1818,9.1747,9.1885,9.1886,9.2148,9.18673,9.2168,9.1149,9.1759,9.2075,9.2208,9.1601,9.1629,9.2171,9.181,9.16446,9.1551,9.203,9.21,9.1712,9.2,9.2162,9.1805,9.2035,9.1971,9.2,9.2,9.1617,9.1868,9.1658,9.1703,9.1801,9.2048,9.1682,9.17524,9.21327,9.2303,9.2035,9.1648,9.1746,9.1549,9.2348,9.2278,9.2058,9.2031,9.1817,9.15282,9.1461,9.2253,9.1822,9.1566,9.183,9.1499,9.2221,9.1868,9.1844,9.2261,9.17648,9.1233,9.1788,9.1837,9.2138,9.18691,9.187,9.1924,9.1973,9.1872,9.1762,9.1993,9.1844,9.1856,9.1473,9.1852,9.156,9.1888,9.15236,9.18402,9.18638,9.16526,9.18837,9.18452,9.14496,9.18709,9.23225,9.1703,9.1703,9.1998,9.1654,9.2235,9.1771,9.2235,9.1733],[7.20785987143248,7.09007683577609,7.37775890822787,8.08641027532378,7.64969262371151,7.00306545878646,7.20785987143248,7.64969262371151,6.80239476332431,8.1605182474775,6.90775527898214,8.9226582995244,7.46737106691756,8.41183267575841,6.95654544315157,7.09007683577609,6.62007320653036,7.20785987143248,6.5510803350434,6.80239476332431,8.1605182474775,6.62007320653036,8.85366542803745,9.61580548008435,7.54960916515453,6.90775527898214,7.57558465155779,9.7981270368783,7.82404601085629,6.68461172766793,8.59711281459211,8.59711281459211,8.9226582995244,7.82404601085629,8.29404964010203,6.85646198459459,7.60090245954208,7.3132203870903,8.29404964010203,9.82552601106642,7.82404601085629,7.49554194388426,7.49554194388426,7.0475172213573,8.10167774745457,7.64012317269536,7.64969262371151,7.27931883541462,7.00306545878646,7.3132203870903,8.1886891244442,8.67145815042767,6.85646198459459,7.69621263934641,7.24422751560335,7.49554194388426,7.77275271646874,7.49554194388426,6.3456363608286,6.10924758276437,7.64012317269536,8.85366542803745,7.00306545878646,7.17011954344963,8.00636756765025,6.47697236288968,6.62007320653036,8.51719319141624,7.24422751560335,6.90775527898214,8.85366542803745,7.82404601085629,6.80239476332431,8.61250337122056,6.5510803350434,6.68461172766793,6.80239476332431,7.94909149983052,6.5510803350434,6.85646198459459,7.0475172213573,7.0475172213573,7.60090245954208,7.17011954344963,7.09007683577609,6.5510803350434,7.97796809312855,6.62007320653036,6.90775527898214,7.3132203870903,6.90775527898214,7.09007683577609,7.0475172213573,6.72142570079064,8.24275634571448,8.00636756765025,6.90775527898214,7.17011954344963,8.29404964010203,7.02108396428914,6.80239476332431,7.09007683577609,7.13089883029635,6.5510803350434,6.62007320653036,6.85646198459459,7.07326971745971,6.30991827822652,7.72973533138505,6.90775527898214,6.5510803350434,7.09007683577609,6.80239476332431,6.25382881157547,7.20785987143248,6.47697236288968,6.74523634948436,7.17011954344963,7.43838353004431,7.5137092478397,7.17011954344963,7.43838353004431,7.17011954344963,8.49699048409872,7.08170858610557,6.95654544315157,7.78322401633604,7.60090245954208,null,7.00306545878646,6.85646198459459,null,7.13089883029635,8.11162807830774,6.7093043402583,6.85646198459459,7.37775890822787,7.20785987143248,6.74523634948436,6.68461172766793,6.86484777797086,7.00306545878646,8.00636756765025,7.43838353004431,7.00306545878646,6.74523634948436,7.64156444126097,7.68063742756094,7.00306545878646,7.34601020991329,6.59304453414244,7.17011954344963,8.33086361322474,7.17011954344963,6.80239476332431,6.85646198459459,7.46737106691756,7.68109900153636,6.90775527898214,7.54960916515453,7.00306545878646,7.9373746961633,7.00306545878646,7.17011954344963,null,7.17011954344963,6.68461172766793,7.1777824161952,7.00306545878646,6.95654544315157,7.09007683577609,6.97541392745595,7.0475172213573,6.90775527898214,7.17011954344963,7.49554194388426,7.09007683577609,6.80239476332431,null,7.00306545878646,6.68461172766793,8.29404964010203,8.80986280537906,8.00636756765025,7.9373746961633,7.3132203870903,7.60090245954208,8.41183267575841,7.17011954344963,6.5510803350434,7.82404601085629,7.9373746961633,8.00636756765025,7.60090245954208,6.90775527898214,8.20685642839965,8.07090608878782,6.65929391968364,7.49554194388426,7.20785987143248,6.74523634948436,7.09007683577609,7.24422751560335,6.62007320653036,7.78945456608667,7.37775890822787,7.34601020991329,9.90348755253613,7.78322401633604,6.74523634948436,7.00306545878646,7.3132203870903,7.56008046502183,7.69621263934641,6.89770494312864,7.13089883029635,6.80128303447162,7.27931883541462,6.80239476332431,8.33086361322474,6.95654544315157,6.5510803350434,8.00636756765025,7.00306545878646,6.80239476332431,7.09007683577609,6.95654544315157,7.3132203870903,7.37775890822787,6.96790920180188,7.22620901010067,6.90775527898214,6.80239476332431,7.17011954344963,7.34601020991329,7.69621263934641,7.7621706071382,7.60090245954208,7.24422751560335,6.77992190747225,7.17011954344963,6.5510803350434,7.94626364358054,6.47697236288968,8.00636756765025,6.62007320653036,6.62007320653036,6.74523634948436,6.39692965521615,7.00306545878646],null,null,{"interactive":true,"className":"","stroke":true,"color":["#440154","#440154","#31688E","#FDE725","#35B779","#440154","#440154","#35B779","#808080","#FDE725","#440154","#808080","#31688E","#FDE725","#440154","#440154","#808080","#440154","#808080","#808080","#FDE725","#808080","#808080","#808080","#31688E","#440154","#31688E","#808080","#FDE725","#808080","#808080","#808080","#808080","#FDE725","#FDE725","#808080","#35B779","#31688E","#FDE725","#808080","#FDE725","#31688E","#31688E","#440154","#FDE725","#35B779","#35B779","#440154","#440154","#31688E","#FDE725","#808080","#808080","#35B779","#440154","#31688E","#35B779","#31688E","#808080","#808080","#35B779","#808080","#440154","#440154","#FDE725","#808080","#808080","#FDE725","#440154","#440154","#808080","#FDE725","#808080","#808080","#808080","#808080","#808080","#FDE725","#808080","#808080","#440154","#440154","#35B779","#440154","#440154","#808080","#FDE725","#808080","#440154","#31688E","#440154","#440154","#440154","#808080","#FDE725","#FDE725","#440154","#440154","#FDE725","#440154","#808080","#440154","#440154","#808080","#808080","#808080","#440154","#808080","#35B779","#440154","#808080","#440154","#808080","#808080","#440154","#808080","#808080","#440154","#31688E","#31688E","#440154","#31688E","#440154","#FDE725","#440154","#440154","#35B779","#35B779","#808080","#440154","#808080","#808080","#440154","#FDE725","#808080","#808080","#31688E","#440154","#808080","#808080","#808080","#440154","#FDE725","#31688E","#440154","#808080","#35B779","#35B779","#440154","#31688E","#808080","#440154","#FDE725","#440154","#808080","#808080","#31688E","#35B779","#440154","#31688E","#440154","#FDE725","#440154","#440154","#808080","#440154","#808080","#440154","#440154","#440154","#440154","#440154","#440154","#440154","#440154","#31688E","#440154","#808080","#808080","#440154","#808080","#FDE725","#808080","#FDE725","#FDE725","#31688E","#35B779","#FDE725","#440154","#808080","#FDE725","#FDE725","#FDE725","#35B779","#440154","#FDE725","#FDE725","#808080","#31688E","#440154","#808080","#440154","#440154","#808080","#35B779","#31688E","#31688E","#808080","#35B779","#808080","#440154","#31688E","#31688E","#35B779","#808080","#440154","#808080","#440154","#808080","#FDE725","#440154","#808080","#FDE725","#440154","#808080","#440154","#440154","#31688E","#31688E","#440154","#440154","#440154","#808080","#440154","#31688E","#35B779","#35B779","#35B779","#440154","#808080","#440154","#808080","#FDE725","#808080","#FDE725","#808080","#808080","#808080","#808080","#440154"],"weight":10,"opacity":0.5,"fill":true,"fillColor":["#440154","#440154","#31688E","#FDE725","#35B779","#440154","#440154","#35B779","#808080","#FDE725","#440154","#808080","#31688E","#FDE725","#440154","#440154","#808080","#440154","#808080","#808080","#FDE725","#808080","#808080","#808080","#31688E","#440154","#31688E","#808080","#FDE725","#808080","#808080","#808080","#808080","#FDE725","#FDE725","#808080","#35B779","#31688E","#FDE725","#808080","#FDE725","#31688E","#31688E","#440154","#FDE725","#35B779","#35B779","#440154","#440154","#31688E","#FDE725","#808080","#808080","#35B779","#440154","#31688E","#35B779","#31688E","#808080","#808080","#35B779","#808080","#440154","#440154","#FDE725","#808080","#808080","#FDE725","#440154","#440154","#808080","#FDE725","#808080","#808080","#808080","#808080","#808080","#FDE725","#808080","#808080","#440154","#440154","#35B779","#440154","#440154","#808080","#FDE725","#808080","#440154","#31688E","#440154","#440154","#440154","#808080","#FDE725","#FDE725","#440154","#440154","#FDE725","#440154","#808080","#440154","#440154","#808080","#808080","#808080","#440154","#808080","#35B779","#440154","#808080","#440154","#808080","#808080","#440154","#808080","#808080","#440154","#31688E","#31688E","#440154","#31688E","#440154","#FDE725","#440154","#440154","#35B779","#35B779","#808080","#440154","#808080","#808080","#440154","#FDE725","#808080","#808080","#31688E","#440154","#808080","#808080","#808080","#440154","#FDE725","#31688E","#440154","#808080","#35B779","#35B779","#440154","#31688E","#808080","#440154","#FDE725","#440154","#808080","#808080","#31688E","#35B779","#440154","#31688E","#440154","#FDE725","#440154","#440154","#808080","#440154","#808080","#440154","#440154","#440154","#440154","#440154","#440154","#440154","#440154","#31688E","#440154","#808080","#808080","#440154","#808080","#FDE725","#808080","#FDE725","#FDE725","#31688E","#35B779","#FDE725","#440154","#808080","#FDE725","#FDE725","#FDE725","#35B779","#440154","#FDE725","#FDE725","#808080","#31688E","#440154","#808080","#440154","#440154","#808080","#35B779","#31688E","#31688E","#808080","#35B779","#808080","#440154","#31688E","#31688E","#35B779","#808080","#440154","#808080","#440154","#808080","#FDE725","#440154","#808080","#FDE725","#440154","#808080","#440154","#440154","#31688E","#31688E","#440154","#440154","#440154","#808080","#440154","#31688E","#35B779","#35B779","#35B779","#440154","#808080","#440154","#808080","#FDE725","#808080","#FDE725","#808080","#808080","#808080","#808080","#440154"],"fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,{"ctKey":["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242","243","244","245","246","247","248","249","250"],"ctGroup":"houses"}]},{"method":"addLegend","args":[{"colors":["#440154","#31688E","#35B779","#FDE725"],"labels":["1,000 &ndash; 1,500","1,500 &ndash; 2,000","2,000 &ndash; 2,500","2,500 &ndash; 5,000"],"na_color":"#808080","na_label":"NA","opacity":0.5,"position":"bottomright","type":"bin","title":"Prices","extra":null,"layerId":null,"className":"info legend","group":null}]},{"method":"addScaleBar","args":[{"maxWidth":100,"metric":true,"imperial":true,"updateWhenIdle":true,"position":"bottomleft"}]}],"setView":[[45.474211,9.191383],13,[]],"limits":{"lat":[45.4361,45.5276],"lng":[9.1149,9.2471]}},"evals":[],"jsHooks":[]}</script>
<div id="htmlwidget-66ecfd12a38b80cc8dc2" class="reactable html-widget" style="width:auto;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-66ecfd12a38b80cc8dc2">{"x":{"tag":{"name":"Reactable","attribs":{"data":{"price":[1350,1200,1600,3250,2100,1100,1350,2100,900,3500,1000,7500,1750,4500,1050,1200,750,1350,700,900,3500,750,7000,15000,1900,1000,1950,18000,2500,800,5416,5416,7500,2500,4000,950,2000,1500,4000,18500,2500,1800,1800,1150,3300,2080,2100,1450,1100,1500,3600,5834,950,2200,1400,1800,2375,1800,570,450,2080,7000,1100,1300,3000,650,750,5000,1400,1000,7000,2500,900,5500,700,800,900,2833,700,950,1150,1150,2000,1300,1200,700,2916,750,1000,1500,1000,1200,1150,830,3800,3000,1000,1300,4000,1120,900,1200,1250,700,750,950,1180,550,2275,1000,700,1200,900,520,1350,650,850,1300,1700,1833,1300,1700,1300,4900,1190,1050,2400,2000,"NA",1100,950,"NA",1250,3333,820,950,1600,1350,850,800,958,1100,3000,1700,1100,850,2083,2166,1100,1550,730,1300,4150,1300,900,950,1750,2167,1000,1900,1100,2800,1100,1300,"NA",1300,800,1310,1100,1050,1200,1070,1150,1000,1300,1800,1200,900,"NA",1100,800,4000,6700,3000,2800,1500,2000,4500,1300,700,2500,2800,3000,2000,1000,3666,3200,780,1800,1350,850,1200,1400,750,2415,1600,1550,20000,2400,850,1100,1500,1920,2200,990,1250,899,1450,900,4150,1050,700,3000,1100,900,1200,1050,1500,1600,1062,1375,1000,900,1300,1550,2200,2350,2000,1400,880,1300,700,2825,650,3000,750,750,850,600,1100],"location":["via paolo da cannobio  37","via tartaglia 7","via antonio kramer  20","via solferino  11","via carlo botta 8","via lecco 4","via friuli 78","via nerino 12","via vittorio alfieri C.A.","via antonio locatelli 5","via delle forze armate 9","via cappuccini C.A.","via giuseppe mercalli 2","via cappuccini C.A.","via guido guinizelli C.A.","viale belisario 9","via louis pasteur 16","corso indipendenza 18","open space piazza emilio salgari C.A.","via giuseppe maria giulietti 8","corso como 9","via rutilia 23","ippodromo 105,","via tommaso salvini 1","via sofonisba anguissola 50a","corso sempione 56","via buonarroti 20","corso giuseppe garibaldi 95","via francesco petrarca C.A.","via mincio C.A.","via tullo morgagni C.A.","via tullo morgagni C.A.","bastioni di porta venezia C.A.","via francesco petrarca C.A.","via motta C.A.","via san vittore 13","corso magenta 32","via carlo torre 39","via borgogna C.A.","via dei giardini C.A.","via della spiga 23","via rodolfo farneti 1","via giulio uberti 10","via tirso 4","viale luigi majno 35","via plinio 24","corso magenta 32","via fatebenesorelle 18","via francesco melzi deril 29,","via carlo torre 43","via vincenzo monti 26","via santagnese 16,","via ambrogio de marchi gherini 14","via polibio 9","via vincenzo magliocco 5","via maurizio quadrio C.A.","via maria teresa C.A.","via dei piatti C.A.","via bari C.A.","via serio C.A.","via giorgio pallavicino 21","ottimo stato secondo piano, C.A.","via fabio filzi 41","via piero della francesca 22","via salvini C.A.","via lodovico muratori 11","via aldo lusardi C.A.","via daniele manin 35","via atto vannucci 20","via della majella 6","via vincenzo capelli 2","via statuto C.A.","via luigi settembrini 37","via vigevano 45","via don giuseppe andreoli 17","piazzale lagosta 10","via cerva 14","via andrea solari C.A.","via demetrio cretese 6","via maestri campionesi C.A.","viale regina giovanna 28","via caminadella 23","via fiori oscuri C.A.","via marghera 10","via ascanio sforza 61","via giacomo watt C.A.","viale bianca maria C.A.","monte cristallo 1","via gaetano osculati 13","via del bollo 6","via carlo botta 9","via giuseppe pozzone C.A.","alzaia naviglio grande C.A.","via sandro botticelli 23","via maurizio quadrio 15","via sforza 1","viale delle rimembranze di greco C.A.","via console flaminio 11","via durini C.A.","via pietro custodi 14","viale toscana 17","via luigi settembrini C.A.","via salasco C.A.","via gaetano osculati 13","via tertulliano 58","corso lodi 102a","via nicolò tartaglia 29","via silvio zambaldi C.A.","via filippo corridoni C.A.","via cesare balbo C.A.","via giovanni rasori C.A.","via andrea solari 60","viale luigi torelli C.A.","via giuditta pasta 125","passaggio degli osii C.A.","via padova 262","via mortara C.A.","ottimo stato quarto piano, C.A.","via andrea solari C.A.","piazza san babila C.A.","via castel morrone 4","via san siro 29","corso concordia C.A.","via madonnina C.A.","buono stato secondo piano, C.A.","ottimo stato quarto piano, C.A.","ottimo stato 11,","ottimo stato nono piano, C.A.","via alessandro manzoni C.A.","corso venezia 19","nuovo, piano terra, C.A.","largo corsia dei servi C.A.","ottimo stato terzo piano, C.A.","via francesco sforza 1","viale corsica 41","viale umbria C.A.","viale umbria 29","viale umbria C.A.","viale umbria 21","via pietro pomponazzi C.A.","via giovanni battista piranesi 43","via cozzi C.A.","piazzale luigi cadorna 4","via meravigli C.A.","via pola C.A.","largo isabella daragona 2,","via bernardino zenale 11","via benedetto marcello 2","via bernardino lanino 5","via olmetto 8","viale umbria C.A.","via francesco caracciolo 68","via santo spirito C.A.","via tolmezzo 12","via perugino 27","via rezia C.A.","via simone dorsenigo, C.A.","via alberto da giussano 17","via francesco brioschi 90","galleria giuseppe borella 3","via san marco C.A.","via fiori oscuri C.A.","via claudio monteverdi C.A.","via solferino C.A.","viale abruzzi 33","via bernabò visconti C.A.","via gaudenzio ferrari 10","ottimo stato secondo piano, C.A.","via laura ciceri visconti C.A.","via arona 4","via principe eugenio 6","viale umbria 76","ottimo stato primo piano, C.A.","via francesco ferrucci C.A.","via giovanni enrico pestalozzi 6","via niccolò copernico 43","via vitruvio 4","via filippo argelati C.A.","via san damiano C.A.","via carlo poma 61","corso di porta ticinese 66","via cappuccini C.A.","piazza della repubblica 19,","via borgogna 7","via borgogna 7","ripa di porta ticinese 107a,","via dellorso, C.A.","piazzale baracca C.A.","via vincenzo monti C.A.","via francesco de sanctis C.A.","via gaetano donizetti 46","ottimo stato quarto piano, C.A.","via san vincenzo C.A.","via mameli C.A.","via gaspare aselli 2","via cappuccini C.A.","via montevideo 19","via giuseppe tartini 37","via giorgio washington C.A.","via pordenone C.A.","via beato angelico C.A.","viale lunigiana 5","via crema 29","viale giovanni da cermenate 50","via roncaglia C.A.","via meloria C.A.","via antonio bazzini 2","via di porta tenaglia C.A.","via elba C.A.","viale gian galeazzo 11","via gaetano previati C.A.","via plinio 70","via del carmine 7","via varese C.A.","via andrea pellizzone 13","via caminadella 23","via angelo inganni 83","via manusardi 4","via ugo bassi 1b,","via luigi da palestrina 10","via solferino  11","piazzale carlo archinto 9","via via sandro sandri 1","via giuseppe ripamonti 13","via fiori chiari 2","piazzale luigi cadorna 10","via panfilo castaldi 4","corso garibaldi 721,","corso garibaldi 104","viale paolo onorato vigliani 21","via col moschin 7","via savona 73","piazzale segrino 5","via sardegna 20","corso garibaldi 721,","piazza pio xi 5","via lorenzo  mascheroni 18","via san marco 12","via farini 63","via rubens 8","via menabrea 12","viale porpora 161","via vincenzo monti C.A.","via catone 21","via borgogna 7","via francesco paolo michetti 22","viale campania 5","ripa  ripa di porta ticinese 5","viale campania 5","via cesare da sesto C.A."],"nroom":["2","2","3","5","3","2","3","3","1","5","2","5+","3","5","3","2","2","2","2","2","5","2","5+","5+","3","2","2","5","5","2","5","5","5+","5","5+","2","2","2","4","5+","2","4","3","2","4","3","2","3","2","2","5+","5+","2","3","3","2","3","3","1","1","3","5+","2","2","3","1","2","5+","3","2","4","3","2","5","2","1","1","3","1","3","2","2","2","3","2","2","4","1","3","1","2","1","3","1","3","3","2","2","4","2","2","2","2","2","2","3","2","2","3","2","1","2","2","2","2","1","2","3","4","2","2","3","2","3","2","2","2","1","3","1","2","3","2","4","2","2","3","3","2","2","2","2","4","2","2","1","3","3","2","2","1","2","5","3","2","3","4","2","2","2","1","3","1","2","1","2","1","2","3","2","3","3","3","2","4","3","2","3","5+","1","2","3","5+","3","3","3","3","4","2","1","2","3","5","3","3","4","5","2","3","3","2","3","3","2","4","2","3","5+","5","2","2","4","3","3","2","2","2","4","2","4","2","1","3","2","1","1","2","2","2","3","2","2","2","2","2","3","3","3","3","2","3","1","3","2","3","2","2","2","1","2"],"condom":[200,250,133,175,125,200,150,370,50,650,100,875,150,416,200,150,50,190,50,0,300,150,750,983,200,150,60,1500,200,100,550,550,1166,200,350,100,150,150,667,1750,250,290,200,250,450,180,150,284,240,150,400,459,150,250,300,150,258,166,80,150,460,0,130,100,333,50,150,1000,70,200,1250,333,100,0,60,100,75,840,0,160,210,50,"NA",100,200,200,416,100,100,125,145,200,20,0,0,333,100,160,500,80,0,0,150,100,50,300,100,150,"NA",100,100,70,150,70,250,50,100,200,300,192,160,280,85,500,0,200,230,160,160,250,50,"NA",113,458,133,100,150,150,100,50,200,100,240,180,100,150,500,150,200,250,70,150,600,200,50,160,250,233,200,150,100,200,175,130,0,170,"NA",90,280,170,350,185,250,150,200,350,150,100,800,290,55,375,920,515,460,100,416,375,200,200,420,400,666,250,200,366,400,220,275,150,90,150,100,150,333,300,350,0,0,150,100,200,250,400,110,50,120,200,75,0,142,70,383,90,166,200,150,200,200,233,190,50,117,150,250,300,400,250,100,208,100,60,375,200,515,250,50,50,50,100],"sqfeet":[70,85,82,195,105,50,75,110,30,160,45,360,95,180,82,51,40,70,40,50,140,57,389,360,110,50,60,369,133,55,335,335,363,133,210,50,65,48,160,415,55,145,100,58,190,120,56,85,55,50,203,209,55,90,105,75,90,89,30,30,124,190,50,50,130,23,45,299,90,45,214,100,50,160,42,35,43,95,23,80,60,45,55,80,50,60,150,40,90,40,72,50,80,35,114,100,58,65,120,50,50,75,68,65,41,90,50,54,90,50,35,55,55,37,55,24,45,85,120,42,70,110,50,130,47,55,67,47,100,35,72,120,50,160,45,60,80,75,50,50,50,70,136,50,55,45,122,107,55,65,40,62,190,85,40,75,110,57,50,85,32,70,70,55,30,65,40,60,86,45,75,80,75,50,140,102,48,65,280,50,35,100,250,110,100,80,85,190,100,36,100,140,165,95,68,120,190,67,156,90,50,52,110,45,130,106,110,350,150,62,57,125,100,125,75,55,55,85,54,206,45,35,100,52,35,37,70,65,69,112,90,50,65,85,80,120,130,110,80,65,80,30,127,50,118,60,55,45,30,60]},"columns":[{"accessor":".selection","name":"","type":"NULL"},{"accessor":"price","name":"price","type":"numeric"},{"accessor":"location","name":"location","type":"character"},{"accessor":"nroom","name":"nroom","type":"character"},{"accessor":"condom","name":"condom","type":"numeric"},{"accessor":"sqfeet","name":"sqfeet","type":"numeric"}],"defaultPageSize":10,"paginationType":"numbers","showPageInfo":true,"minRows":10,"selection":"multiple","onClick":"select","rowStyle":{"cursor":"pointer"},"crosstalkKey":["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242","243","244","245","246","247","248","249","250"],"crosstalkGroup":"houses","dataKey":"061a5493c53f919c1d3c0a1ae5005dca","key":"061a5493c53f919c1d3c0a1ae5005dca"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

Predictors, in this case latitude and longitude appear to have nonlinear relationships with the outcome price. The relationship appears to be Gaussian whose mean points to the city center, red dashed line represent latitude and longitude coordinates for the Dome of Milan. Non linearities can be treated with regression splines

<div class="figure">
<img src="06-exploratory_files/figure-html/NonLinearSpatialRel-1.png" alt="Non Linear Spatial Relationship disclosed" width="672" />
<p class="caption">(\#fig:NonLinearSpatialRel)Non Linear Spatial Relationship disclosed</p>
</div>


ggplot2 visualzitaion matt dancho inspiration::




## Counts and First Orientations

Arranged Counts for categorical columns can give a sense of the distribution of categories across the dataset suggesting also which predictor to include in the model. The visualization in figure \@ref(fig:fctCounts) offers the rearranged factor *TOTLOCALI*. 
Bilocali are the most common option for rent, then trilocali comes after. The intuition behind suggests that Milan rental market is oriented to "lighter" accommodations in terms of space and squarefootage. This should comes natural since Milan is both a vivid study and working area, so short stayings are warmly welcomed.

<div class="figure">
<img src="06-exploratory_files/figure-html/fctCounts-1.png" alt="Count plot for each housedolds category" width="672" />
<p class="caption">(\#fig:fctCounts)Count plot for each housedolds category</p>
</div>

Two of the most requested features for comfort and livability in rents are the heating/cooling systems. Moreover rental market demand, regardless of the rent duration, strives for a ready-to-accomodate offer to meet clients expectation. In this sense accommodation coming with the newest and the most technologically advanced systems are naturally preferred. 
x-axis in figure \@ref(fig:PricePerAc) represents $\log_{10}$ price for both of the upper and lower panel. Logarithmic scale is needed to smooth distributions and the resulting price interpretation have to considered into relative percent changes. Furthermore factors are reordered with respect to decreasing price.  
y-axis are the different level for the categorical variables recoded from the original data due to simplify lables and to hold plot dimension. Moreover counts per level are expressed between brackets close to their respective factor.
The top plot displays the most prevalent heating systems categories, among which the most prevalent is "Cen_Rad_Met" by far. This fact is extremely important since metano is a green energy source and if the adoption is wide spread and pipelines are well organized than it brings enormous benefit to the city. As a consequence one major concern regards that for many years policies have been oriented to reduce vehicles emission (euro1 euro2...) instead of focusing on house emissions. This was also a consequence of the lack of house data especially in rural areas. According to data there are still a 15% portion of houses powered by oil fired. 
Then in bottom plot Jittering is then applied to point out the number of outliers outside the IQR (Inter Quantile Range) .25 and their impact on the distribution. A first conclusion is that outliers are mainly located in autonomous systems, which leads of course to believe that the most expensive houses are heated by autonomoius heating systems. Indedd in any case this fact that does not affect monthly price. The overlapping IQR signifies that the covariates levels do not impact the response variable.


<div class="figure">
<img src="06-exploratory_files/figure-html/PricePerAc-1.png" alt="Log Monthly Prices box-plots for the most common factor levels in Heating systems and Air Conditionings" width="672" />
<p class="caption">(\#fig:PricePerAc)Log Monthly Prices box-plots for the most common factor levels in Heating systems and Air Conditionings</p>
</div>





VALE LA PENA GUARDARE QUELLE CHE SI SONO ABBASSATE DI PREZZO E DOVE SONO e magari desumere il perchè (magari vedere che sono più a stundente che a non studente) --> questo implica fare un'analisi di covid il che è buono perchèè pè un'analisi bella fresca





<!-- this visualization intersects allows to discover bimodality in the response variable.  Log scales was needed since they are all veru skewd and log scale then is needed also in the model. -->

<!-- (qui ci puoi mettere a confronto per variabile bianria, così vedi cosa includere nel modello esempio sotto dove commentato, ) -->

<!-- ```{r} -->
<!-- ## non filled -->
<!-- non_fill = datiprep2 %>% -->
<!--   add_count(totlocali, name  = "totlocali_count") %>%  -->
<!--   mutate(totlocali = glue("{ totlocali } ({ totlocali_count })"), -->
<!--          totlocali = fct_reorder(totlocali, price)) %>%  -->
<!--   ggplot(aes(price, totlocali, fill = accdisabili)) +  -->
<!--   geom_density_ridges(alpha = .5) + -->
<!--   scale_x_log10(labels = dollar_format(suffix = "€", prefix = "")) + -->
<!--   labs(x = "Price (EUR)", -->
<!--        y = "", -->
<!--        title = "How much do Cost items in each category cost?") + -->
<!--   theme_nicco() -->


<!-- with_fill = datiprep2 %>% -->
<!--   add_count(totlocali, name  = "totlocali_count") %>%  -->
<!--   mutate(totlocali = glue("{ totlocali } ({ totlocali_count })"), -->
<!--          totlocali = fct_reorder(totlocali, price)) %>%  -->
<!--   ggplot(aes(price, totlocali,fill = ascensore)) + ## qui fill con v avriabile bianria -->
<!--   geom_density_ridges(alpha = .5) + -->
<!--   scale_x_log10(labels = dollar_format(suffix = "€", prefix = "")) + -->
<!--   labs(x = "Price (EUR)", -->
<!--        y = "", -->
<!--        title = "How much do Cost items in each category cost?") + -->
<!--   theme_nicco() -->

<!-- with_fill / non_fill -->
<!-- ``` -->

What it might be really relevant to research is how monthly prices change with respect to house square footage for each house configuration. The idea is to asses how much adding a further square meter affetcs the monthly price for each n-roomed flat.
One implication is how the property should be developed in order to request a greater amount of money per month. As an example in a situation in which the household has to lot its property into different sub units he can be helped to decide the most proficient choice in economic terms by setting ex ante the square footage extensions for each of the sub-properties.
A further implication can regard economic convenience to enlarge new property acquisitions under the expectation to broadened the square footage (construction firms). Some of the potential enlargements are economically justified, some of the other are not.
The plot  \@ref(fig:GlmPriceSq) has two continuous variables for x (price) and y (sqfeet) axis, the latter is log 10 scaled due to smoothness reasons. Coloration discretizes points for the each $j$ household rooms totlocali. A sort of overlapping  piece-wise linear regression (log-linear due to transformation) is fitted on each totlocali group, whose response variable is price and whose only predictor is the square footage surface (i.e.  $\log_{10}(\mathbf{price_j}) \sim +\beta_{0,j}+\beta_{1,j}\mathbf{sqfeet_j}$). Five different regression models are proposed in the top left. The interesting part regards the models slopes $\hat\beta_{1,j}$. The highest corresponds to "Monolocale" for which the enlargement of a 10 square meters in surface enriches the apartment of a 0.1819524% monthly price addition. Almost the same is witnessed in "Bilocale" for which a 10 square meters extension gains a 0.1194379% value. One more major thing to notice is the "ensamble" regression line obtained as the interpolation of the 5 plotted ones. The line suggests a clear slope descending pattern (logarithmic trend) from Pentalocale and beyond whose assumption is strengthened by looking at the decreasing trend in the $\hat\beta_1$ predictor slopes coefficients. Furthermore investing into an extension for "Quadrilocale" and "Trilocale" is _coeteris paribus_ an interchangeable economic choice.

<div class="figure">
<img src="06-exploratory_files/figure-html/GlmPriceSq-1.png" alt="Monthly Prices change wrt square meters footage in different n-roomed apt" width="672" />
<p class="caption">(\#fig:GlmPriceSq)Monthly Prices change wrt square meters footage in different n-roomed apt</p>
</div>

In table (...) resides the answer to the question "which are the most profitable properties per month in terms of the price per square meter footage ratio". The covariate floor together with the totpiani are not part of the model, indeed they can explain the importance and the height of the building justifying extraordinary prices.  The first 4 observations are unsurprisingly "Bilocale", the spatial column location, not a regressor, can lend a hand to acknowledge that the street addresses point to very central and popular zones. The zones are, first City Life, second Brera and third Moscova, proving that in modeling real estate rents the spatial component is fundamental , even more in Milan. 

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
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> via di porta tenaglia C.A. </td>
   <td style="text-align:left;"> 5+ </td>
   <td style="text-align:right;"> 20000 </td>
   <td style="text-align:right;"> 350 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 2 piani </td>
   <td style="text-align:right;"> 57.14286 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> corso giuseppe garibaldi 95 </td>
   <td style="text-align:left;"> Pentalocale </td>
   <td style="text-align:right;"> 18000 </td>
   <td style="text-align:right;"> 369 </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 5 piani </td>
   <td style="text-align:right;"> 48.78049 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> via della spiga 23 </td>
   <td style="text-align:left;"> Bilocale </td>
   <td style="text-align:right;"> 2500 </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 4 piani </td>
   <td style="text-align:right;"> 45.45455 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> via dei giardini C.A. </td>
   <td style="text-align:left;"> 5+ </td>
   <td style="text-align:right;"> 18500 </td>
   <td style="text-align:right;"> 415 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 6 piani </td>
   <td style="text-align:right;"> 44.57831 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> piazza san babila C.A. </td>
   <td style="text-align:left;"> Bilocale </td>
   <td style="text-align:right;"> 1833 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 4 piani </td>
   <td style="text-align:right;"> 43.64286 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ottimo stato nono piano, C.A. </td>
   <td style="text-align:left;"> Monolocale </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:left;"> 9 </td>
   <td style="text-align:left;"> 11 piani </td>
   <td style="text-align:right;"> 42.55319 </td>
  </tr>
</tbody>
</table>

Then as a further point it might be important to investigate a linear model whose response is price and whose covariates are the newly created abs_price and some other presumably important ones e.g. floor, bagno, totpiani. The model fitted is `log2(price) ~ log2(abs_price) + bagno + floor + totpiani`.
The plot in figure \@ref(fig:TieFighterPlot) has the purpose to demonstrate how monthly price is affected by covariates conditioned to their respective square meter footage. The interpretation of the plot starts by fixing a focus point on 0, which is the null effect highlighted by the red dashed line. Then the second focus is on house surface effect (i.e. House Surface (doubling) in the plot, the term log2(abs_price) has been converted to more familiar House Surface (doubling)), which contributes to increase the price of an estimated coefficient of $\approx .6$ for each doubling of the square meter footage. Then what it can be noticed with respect to the two focus points are the unusual effects provoked by the other predictors t the right of the house surface effect and to the far left below 0. "2 and 3 bagni" are unusually expensive with respect to the square meter footage increment, on the other hand" al piano rialzato" and "al piano terra" are undervalued with respect to their surface.  The fact that 2 and 3 bathrooms can guarantee a monthly extra check is probably caused to a minimum rent plateau requested for each occupant. the number of bathrooms are a proxy to both house extension since normally for each sleeping room there also exist at least 1 bathroom as well as prestigious houses dispose of more than 1 toilette services. So the more are the occupants regardless of the square meter footage dedicated to them, the more the house monthly returns,


it can be noticed is that ultimo piano, otgether with 2 abagni ad 3 bagni are unusually expensive with respect to their proper square meter footage. On the other hand the piano rialzato and piano terra are unusually undervalued given their surface.  
In other words the  to help with the interpretation. The fact that 2 and 3 bathrooms can guarantee a monthly extra check is probably caused to a minimum rent plateau requested for each occupant. So the more are the occupants regardless of the square meter footage dedicated to them, the more the house returns. The conclusion 

Tie fighter coefficient plot for the linear model: $\log_{2}(price) \sim \log_{2}(abs\_price) + condominium + other_colors$

<!-- # ```{r, eval = FALSE} -->
<!-- #  -->
<!-- # library(tidyverse) -->
<!-- # library(broom) -->
<!-- # prova = datiprep_sq %>% -->
<!-- #  mutate(totpiani = fct_lump(totpiani, 5), -->
<!-- #         floor = fct_lump(floor,10)) %>%  -->
<!-- #  filter(floor != "Other") %>%   -->
<!-- #  filter(totpiani != "Other")  %>%  -->
<!-- #  filter(!is.na(.))  -->
<!-- #  model = inla(log2(price) ~ log2(abs_price) + bagno + floor + totpiani  , family = "normal", data = prova)  %>%  -->
<!-- #    .$summary.fixed -->
<!-- #  model %>%  -->
<!-- #    tidy(model, conf.int =T ) -->
<!-- #  -->
<!-- # ``` -->


<div class="figure">
<img src="06-exploratory_files/figure-html/TieFighterPlot-1.png" alt="Tie fighter coefficient plot for the log-linear model" width="672" />
<p class="caption">(\#fig:TieFighterPlot)Tie fighter coefficient plot for the log-linear model</p>
</div>


## Text Mining in estate Review

The word network in figure \ref(fig:WordNetworkgraph) tries to summarize relevant information from real estate agency review into each advertisement. avg_totprice expresses the sum of the price per month plus the condominium in order to fulzly integrate inner property characteristics together with building exclusivity. Tokenized words are then filtered with "stopwords-iso" italian dictionary. 
Nodes associated with hotter colours are also associated to more expensive in and out-house characteristics. The size of nodes keeps track of the number of reviews in which the specific word appears. A table of the most common words can help highlight both the real estate jargon as well as words that brings up house values. 

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> word </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> reviews </th>
   <th style="text-align:right;"> avg_totprice </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> bagno </td>
   <td style="text-align:right;"> 249 </td>
   <td style="text-align:right;"> 192 </td>
   <td style="text-align:right;"> 1888.622 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> cucina </td>
   <td style="text-align:right;"> 247 </td>
   <td style="text-align:right;"> 190 </td>
   <td style="text-align:right;"> 2088.814 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ingresso </td>
   <td style="text-align:right;"> 194 </td>
   <td style="text-align:right;"> 173 </td>
   <td style="text-align:right;"> 1964.062 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> soggiorno </td>
   <td style="text-align:right;"> 182 </td>
   <td style="text-align:right;"> 159 </td>
   <td style="text-align:right;"> 1872.500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> camera </td>
   <td style="text-align:right;"> 200 </td>
   <td style="text-align:right;"> 158 </td>
   <td style="text-align:right;"> 1936.945 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> piano </td>
   <td style="text-align:right;"> 197 </td>
   <td style="text-align:right;"> 157 </td>
   <td style="text-align:right;"> 1982.234 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> arredato </td>
   <td style="text-align:right;"> 184 </td>
   <td style="text-align:right;"> 152 </td>
   <td style="text-align:right;"> 1744.614 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> composto </td>
   <td style="text-align:right;"> 158 </td>
   <td style="text-align:right;"> 146 </td>
   <td style="text-align:right;"> 1758.911 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> riscaldamento </td>
   <td style="text-align:right;"> 171 </td>
   <td style="text-align:right;"> 144 </td>
   <td style="text-align:right;"> 1877.404 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> zona </td>
   <td style="text-align:right;"> 282 </td>
   <td style="text-align:right;"> 139 </td>
   <td style="text-align:right;"> 1930.213 </td>
  </tr>
</tbody>
</table>





Furthermore it is possible to grossly divide the plot in figure \ref(fig:WordNetworkgraph) into 3 sub-groups of nodes, each of which addresses a specific part of the house comprehensive evaluation.
In the far right side of the plot are considered the external appliances like neighbor stores, subway stations and services and are associated to mean prices. The correspondent number of reviews are not justifying by any type of price increasing effect. Whereas slightly moving the view to the left, the area centered in portineria evidences a sub-groups of nodes associated to relatively higher avg-totprice. Some of them are servizio signorile palazzo. The previous set of nodes indicates services that are proper to the building can lead to some sort of extra payment. Then still moving 
Possiamo immaginare di dividere il network in 3 raggruppamenti di nodi, ognuno dei quali parla di uni specifico tema. nella parte alta sinistra csi parla delle circostanze estenre dell'appartamente, i negozi i mezzi serizi la metri, i prezzi evidenzziati dal colore nei nodi sono neutri, indicando che non impattano il prezzo in maniera significativa. poco più sotto è possibile vedere un altro centroide verso il quale puntano  una serie di edges peritenti che riguardano i servizi interni al building come la portinerua, l'ingresso, il palazzo. in questo caso i colori sono più caldi e i servizi sembrano essere pagati di più. successivamente sosptandoci veros il centro del'network si nota un nodo di gravità attorno alquale si trovamo molti outgoing edges, che riscaldamento. Attorno a riscaldamento che vista la grandezza ricorre spesso nelle recensioni, si sviluppano tutti i servizi non descritti da immobiliare all'interno della casa, insiema a tutte le caratteristiche cbe distinguono la casa revisionata dalle altre. i colori degradano spostandosi da sinistra verso destea, accanto a riscaldmaento si nota un cluster che associati a prezzi minoro come spese condominiali e arredato arredato. nel caso delle spese condominiali i cluster sono associati a prezzi minori perchè il prezzo del conominio spesso non è commisurato al prezzo nè al prestigio dell'appartamento. Speso infatti include costi variabili come utenze gas e luce, o acqua che vengono scontati con prezzi più bassi di affitto. la somma di condominio e prezzo offrirebbe un panorama più chiaro. 


<div class="figure">
<img src="06-exploratory_files/figure-html/WordNetworkgraph-1.png" alt="Word Network Graph for 250 Estate Agencies Review" width="672" />
<p class="caption">(\#fig:WordNetworkgraph)Word Network Graph for 250 Estate Agencies Review</p>
</div>



## Missing Assessement and Imputation{#missassimp}

Some data might be lost since immobiliare provides the information that in turn are pre filled by estate agencies or privates through standard document formats. Some of the missing can be reverse engineered by other information in the web pages e.g. given the street address it is possible to trace back the lat and long coordinates. Some other information can be encountered in .json files hidden inside each of the single web pages.
The approach followed in this part is to prune redundant data and rare predictors trying to limit the dimensionality of the dataset.

### Missing assessement 

The first problem to assess is why information are missing. As already pointed out in the preliminary part as well as in section \@ref(ContentArchitecture) many of the presumably important covariates (i.e. price lat, long, title ,id ...) undergo to a sequence of forced step inside scraping functions with the aim to avoid to be lost. If at the end of the sequence covariates are still missing, the correspondent observation is not considered and it is left out of the resulting scraped dataset. The choice originates from empirical missing patterns suggesting that when important information are missing then the rest of the covariates are more likely to be missing to, as a consequence the observation should be discarded.
The missing profile is crucial since it can also raise suspicion on the scraping failures. By Taking advantage of the missing pattern in observations the maintainer can directly identify the problem and derivatives and immediately debug the error. In order to identify if the nature of the pattern a revision of missing and randomness is introduced by @Little.
Missing can be devided into 3 categories:

- *MCAR* (missing completely at random) likelihood of missing is equal for all the information, in other words missing data are one idependetn for the other.
- *MAR* (missing at random) likelihood of missing is not equal.
- *NMAR* (not missing at random) data that is missing due to a specific cause, scarping can be the cause.

MNAR is often the case of daily monitoring clinical studies [@Kuhn], where patient might drop out the experiment because of death and so all the relating data starting from the death time +1 are lost.
To identify the pattern a _heat map_  plot \@ref(fig:Heatmap) clarifies the idea:

<div class="figure">
<img src="06-exploratory_files/figure-html/Heatmap-1.png" alt="Missingness Heatmap plot" width="672" />
<p class="caption">(\#fig:Heatmap)Missingness Heatmap plot</p>
</div>

Looking at the top of the heat map plot, right under the "Predictor" label, the first tree split divides predictors into two sub-groups. The left branch considers from *TOTPIANI* to *CATASTINFO* and there are no evident patterns. Then missingness can be traced back to MAR. Imputation needs to be applied up to *CONDOM* included, the others are discarded due to rarity: i.e. *BUILDAGE*: 14% missing, *CATASTINFO*: 21% and *AC*: 24%. Moreover *CUCINA* and *ALTRO* are generated as "childred" of the original *LOCALI* variable, so it should not surprise that their missing behavior is similar ,whose prevalence is respectively 13% and 14%, for that reason are discarded. 
In the far right hand side *ENCLASS* and *DISP* data are completely missing and a pattern seems to be found. The most obvious reason is a scraping fail in capturing data. Further inspection of the API scraping functions focused on the two covariates is strongly advised. From *LOWRDPRICE.* covariates gorup class it seems to be witnessing a missing underlining pattern NMAR which is clearer by looking at the co_occurrence plot in figure \@ref(fig:cooccurrence). Co-occurrence analysis might suggest frequency of missing predictor in combination and *LOWRDPRICE.* class covariates are displaying this type of behavior. *PAUTO* is missing in the place where *LOWRDPRICE.* class covariates are missing, but this is not happening for the opposite, leading to the conclusion that *PAUTO* should be treated as a rare covariate MAR, therefore *PAUTO* is dropped.
After some further investigation on *LOWRDPRICE.*, the group class flags when the *PRICE* covariate is effectively decreased and this is unusual. That is solved by grouping the covariate's information and to encode it as a two levels categorical covariate if lowered or not. Further methods to feature engineer the *LOWRDPRICE.* class covariates can be with techniques typical of profile data, further references are on @Kuhn.

<div class="figure">
<img src="06-exploratory_files/figure-html/cooccurrence-1.png" alt="Missingness co-occurrence plot" width="672" />
<p class="caption">(\#fig:cooccurrence)Missingness co-occurrence plot</p>
</div>

### Missing Imputation


A relatively simple approach to front missingness is to build a regression model to explain the covariates that have some missing and plug-back-in the respective estimates (e.g. posterior means) from their predictive distributions @Little. This approach is fast and easy to implement in most of the cases, but it ignores the uncertainty behind the imputed values [@Bayesian_INLA_Rubio]. However it has the benefit to be a more than a reasonable choice with respect to the number of computation required, especially with INLA and in a spatial setting. That makes it the first choice method to follow since imputation regards also a small portion of data and predictors. At first it is considered the predictor _condominium_  for which some observation are missing. Indices are:


```
##  [1]  19  74  77  90  99 113 116 120 179 249
```



<!-- and a benchmark model is fitted whose formula is `price ~ 1 + condom + bagno + sqfeet`. Inla handles missing data by ignoring them so the model trains coefficients on a restricted sample of observations. -->

<!-- ```{r} -->
<!-- ## benchmark model -->
<!-- benchmark = inla(price ~ 1+ condom + totlocali + sqfeet, data = data_miss) -->
<!-- benchmark$summary.fixed %>%  -->
<!--   rownames_to_column(var = "terms") %>%  -->
<!--   as_tibble() %>%  -->
<!--   select(terms:sd) %>%  -->
<!--   column_to_rownames(var = "terms")  %>% -->
<!--   head(6) %>%  -->
<!--   knitr::kable(booktabs = T) -->

<!-- ``` -->


A model is fitted based on missing data for which the response var is condominium and predictors are other important explanatory ones, i.e.`condom ~ 1 + sqfeet + totlocali + floor + heating + ascensore`. In addition to the formula in the inla function a further specification has to be provided with the command `compute = TRUE` in the argument control.predictor. The command `compute` estimates the posterior means of the predictive distribution in the response variable for the missing points. The estimated posetior mean quantities are then imputeda are in table \@red(tab:CondomImputation)

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> mean </th>
   <th style="text-align:right;"> sd </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.019 </td>
   <td style="text-align:right;"> 198.11095 </td>
   <td style="text-align:right;"> 19.67085 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.074 </td>
   <td style="text-align:right;"> 162.96544 </td>
   <td style="text-align:right;"> 13.29456 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.077 </td>
   <td style="text-align:right;"> 99.38197 </td>
   <td style="text-align:right;"> 32.34108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.090 </td>
   <td style="text-align:right;"> 331.73519 </td>
   <td style="text-align:right;"> 33.05035 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.099 </td>
   <td style="text-align:right;"> 170.54068 </td>
   <td style="text-align:right;"> 12.30267 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.113 </td>
   <td style="text-align:right;"> 196.61593 </td>
   <td style="text-align:right;"> 15.86545 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.116 </td>
   <td style="text-align:right;"> 108.40482 </td>
   <td style="text-align:right;"> 20.79689 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.120 </td>
   <td style="text-align:right;"> 162.86977 </td>
   <td style="text-align:right;"> 25.61622 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.179 </td>
   <td style="text-align:right;"> 165.03632 </td>
   <td style="text-align:right;"> 20.53485 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> fitted.Predictor.249 </td>
   <td style="text-align:right;"> 117.24234 </td>
   <td style="text-align:right;"> 30.80290 </td>
  </tr>
</tbody>
</table>


<!-- Afterwards the benchmark model is refitted in imputed data and coefficients are compared with the missing. Results displays... -->

<!-- ```{r refitting} -->

<!-- data_imputed = data.frame(data_miss) -->
<!-- data_imputed$condom[condom_na] = cov_imputation$summary.fitted.values[condom_na, "mean"] -->
<!-- which(is.na(data_imputed$condom)) -->

<!-- refitted = inla(price ~ 1 + condom + totlocali+ sqfeet, data = data_imputed) -->
<!-- refitted %>%  summary() -->
<!--   rownames_to_column(var = "terms") %>%  -->
<!--   as_tibble() %>%  -->
<!--   select(terms:sd) %>%  -->
<!--   column_to_rownames(var = "terms")  %>% -->
<!--   head(6) %>%  -->
<!--   knitr::kable(booktabs = T) -->
<!-- ``` -->

 



