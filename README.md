# Educational_Justice_Visualization_Project

**Domain of Interest**

- **Why are you interested in this field/domain?**
  - We are interested in analyzing educational data because it often shows social injustice. Indicators such as school amenities, school funding, graduation rate, dropout rate, and more could show if districts are receiving disproportionate support. We would also like to investigate how primary and secondary education data relates to post-secondary education data. If able, we are also interested in analyzing how access to environmental education and outdoor spaces impacts students post-graduation (such impacts could include belief in climate change). Social and environmental justice are connected because climate change will disproportionately impact low-income communities (and due to systematic injustices people of color disproportionately make up low income communities). We believe that education data may highlight many of these injustices and we are interested in uncovering some these problems. It is critical that we continue uncovering social and environmental injustices to protect the health and well-being of all communities.

- **What other examples of data driven project have you found related to this domain (share at least 3)?**
  - [Getting Climate Studies Into Schools](https://www.nytimes.com/2020/09/02/climate/schools-climate-curriculum.html?searchResultPosition=106)
  - [Hotter Days Widen Racial Gap in U.S. Schools, Data Shows](https://www.nytimes.com/2020/10/05/climate/heat-minority-school-performance.html?searchResultPosition=1)
  - [Environmental Education in Rural Areas](https://nces.ed.gov/surveys/ruraled/environment.asp)

- **What data-driven questions do you hope to answer about this domain (share at least 3)?**
  - How does the number of environmental classes taken impact a student's belief in climate change?
  - How does public school funding impact students' future income?
  - How does public school funding impact dropout rate?
  - How does a school district's average income affect access to environmental classes?
  - How does a school district's average income affect dropout rate?
  - Does a community's environmental beliefs impact available environmental information/classes in public schools)?


***

 **Data**

  * **Where did you download the data (e.g., a web URL)?**
    * The datasets we have found so far are all from the National Center for Education Statistics (NCES), downloaded from their [website](https://nces.ed.gov/programs/edge/Home). By using multiple datasets from the same source, we can ensure that the datasets will all play nicely together with minimal coaxing. For example, the NCES categorizes its data in multiple ways, including school name, and all of their datasets have the same capitalization and abbreviation conventions within these categories. We may look for more datasets to add to our analysis and help us answer some of our research questions more in depth further into the project.

  * **How was the data collected or generated? Make sure to explain who collected the data (not necessarily the same people that host the data), and who or what the data is about?**
    * Each dataset from the NCES comes with a document detailing the methodologies behind the collection of the data, explanations of the individual parameters, discussion on the possible implications or inaccuracies in the data due to the collection methods or other limitations. Most of the data in our selected datasets comes either directly from US Census data, or is derived from US Census data.

  * **How many observations (rows) are in your data?**
    * Some NCES datasets are grouped by school and have 100552 rows. Some are grouped by School District, which have 11911 rows. Datasets by county have 3143 rows.

  * **How many features (columns) are in the data?**
    * School neighborhood Poverty Estimates (2015-2016) - contains 4 columns
    * Selected Economic Characteristics of Relevant Children Enrolled - contains 444 columns
    * Comparable Wage Index for Teachers (CWIFT) - contains 6 columns

  * **What questions (from above) can be answered using the data in this dataset?**
    * Our research questions can be broken down into two categories, those that look at time in primary and secondary education, and those that look at time following primary and secondary education. As in, some questions look at a students time in school, and other look at a students time after graduation (not including post-secondary school). These initial datasets give us a lot of information to look at to form some base analyses on a students time in school, which will allow us to answer that first category of research questions, and set us up to answer the second category with further data. We hope that we can find useful datasets for the second group of research questions.

***

  **Note**

  More applicable datasets that have not been closely looked at yet but may be useful:

  * [Yale Climate Opinion Maps 2020](https://climatecommunication.yale.edu/visualizations-data/ycom-us/)
    * > "These maps show how Americans’ climate change beliefs, risk perceptions, and policy support vary at the state, congressional district, metro area, and county levels."

      Can be linked geographically (likely by county) to our school data. Not specifically the opinions of school-age individuals, but can certainly contribute to interesting analysis.
