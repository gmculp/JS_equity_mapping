const legend_specs = {
  "legends": [
    {
      "var_name": "all_all",
      "title": "Index of variables that likely contribute to energy insecurity/energy burden",
      "source": "2022 CDC BRFSS, 2022 USCB ACS5, 2021 USGS NLCD, 2021 PG&E PSPS, 2024 EPA EJSCREEN, 2023 University of Richmond DSL",
      "contents": [
        {
          "label": "very low vulnerability",
          "color": "#000052"
        },
        {
          "label": "low vulnerability",
          "color": "#3A008C"
        },
        {
          "label": "moderate vulnerability",
          "color": "#7800AB"
        },
        {
          "label": "high vulnerability",
          "color": "#BF009F"
        },
        {
          "label": "very high vulnerability",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "all_environmental",
      "title": "All environmental variables",
      "source": "2021 USGS NLCD, 2024 EPA EJSCREEN",
      "contents": [
        {
          "label": "very low vulnerability",
          "color": "#000052"
        },
        {
          "label": "low vulnerability",
          "color": "#3A008C"
        },
        {
          "label": "moderate vulnerability",
          "color": "#7800AB"
        },
        {
          "label": "high vulnerability",
          "color": "#BF009F"
        },
        {
          "label": "very high vulnerability",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "all_health_dis",
      "title": "All health and disability variables",
      "source": "2022 CDC BRFSS",
      "contents": [
        {
          "label": "very low vulnerability",
          "color": "#000052"
        },
        {
          "label": "low vulnerability",
          "color": "#3A008C"
        },
        {
          "label": "moderate vulnerability",
          "color": "#7800AB"
        },
        {
          "label": "high vulnerability",
          "color": "#BF009F"
        },
        {
          "label": "very high vulnerability",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "all_house_energy",
      "title": "All housing and energy variables",
      "source": "2022 CDC BRFSS, 2022 USCB ACS5, 2021 PG&E PSPS, 2023 University of Richmond DSL",
      "contents": [
        {
          "label": "very low vulnerability",
          "color": "#000052"
        },
        {
          "label": "low vulnerability",
          "color": "#3A008C"
        },
        {
          "label": "moderate vulnerability",
          "color": "#7800AB"
        },
        {
          "label": "high vulnerability",
          "color": "#BF009F"
        },
        {
          "label": "very high vulnerability",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "all_soc_dem",
      "title": "All sociodemographic variables",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "very low vulnerability",
          "color": "#000052"
        },
        {
          "label": "low vulnerability",
          "color": "#3A008C"
        },
        {
          "label": "moderate vulnerability",
          "color": "#7800AB"
        },
        {
          "label": "high vulnerability",
          "color": "#BF009F"
        },
        {
          "label": "very high vulnerability",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "CANCER",
      "title": "Percentage of adults experiencing cancer (non-skin) or melanoma",
      "source": "2022 CDC BRFSS",
      "contents": [
        {
          "label": "1% - 4.8%",
          "color": "#000052"
        },
        {
          "label": ">4.8% - 5.8%",
          "color": "#3A008C"
        },
        {
          "label": ">5.8% - 7%",
          "color": "#7800AB"
        },
        {
          "label": ">7% - 9%",
          "color": "#BF009F"
        },
        {
          "label": ">9% - 23.1%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "CASTHMA",
      "title": "Percentage of adults currently experiencing asthma",
      "source": "2022 CDC BRFSS",
      "contents": [
        {
          "label": "5.9% - 8.3%",
          "color": "#000052"
        },
        {
          "label": ">8.3% - 9%",
          "color": "#3A008C"
        },
        {
          "label": ">9% - 9.6%",
          "color": "#7800AB"
        },
        {
          "label": ">9.6% - 10.3%",
          "color": "#BF009F"
        },
        {
          "label": ">10.3% - 14.1%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "CHD",
      "title": "Percentage of adults experiencing coronary heart disease",
      "source": "2022 CDC BRFSS",
      "contents": [
        {
          "label": "1% - 4.2%",
          "color": "#000052"
        },
        {
          "label": ">4.2% - 4.9%",
          "color": "#3A008C"
        },
        {
          "label": ">4.9% - 5.4%",
          "color": "#7800AB"
        },
        {
          "label": ">5.4% - 6.1%",
          "color": "#BF009F"
        },
        {
          "label": ">6.1% - 28.9%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "child_hh",
      "title": "Percentage of households with young children (age <= 5 years)",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 3%",
          "color": "#000052"
        },
        {
          "label": ">3% - 5%",
          "color": "#3A008C"
        },
        {
          "label": ">5% - 7%",
          "color": "#7800AB"
        },
        {
          "label": ">7% - 9%",
          "color": "#BF009F"
        },
        {
          "label": ">9% - 41%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "COPD",
      "title": "Percentage of adults experiencing chronic obstructive pulmonary disease",
      "source": "2022 CDC BRFSS",
      "contents": [
        {
          "label": "0.9% - 3.4%",
          "color": "#000052"
        },
        {
          "label": ">3.4% - 4.1%",
          "color": "#3A008C"
        },
        {
          "label": ">4.1% - 4.8%",
          "color": "#7800AB"
        },
        {
          "label": ">4.8% - 5.7%",
          "color": "#BF009F"
        },
        {
          "label": ">5.7% - 19.7%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "cost_burden_50",
      "title": "Percentage of households where housing costs exceed 50% of household income",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 10%",
          "color": "#000052"
        },
        {
          "label": ">10% - 14%",
          "color": "#3A008C"
        },
        {
          "label": ">14% - 17%",
          "color": "#7800AB"
        },
        {
          "label": ">17% - 22%",
          "color": "#BF009F"
        },
        {
          "label": ">22% - 82%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "crowd",
      "title": "Percentage of household with more than one occupants per room",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 1%",
          "color": "#000052"
        },
        {
          "label": ">1% - 4%",
          "color": "#3A008C"
        },
        {
          "label": ">4% - 7%",
          "color": "#7800AB"
        },
        {
          "label": ">7% - 12%",
          "color": "#BF009F"
        },
        {
          "label": ">12% - 70%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "DIABETES",
      "title": "Percentage of adults diagnosed with diabetes",
      "source": "2022 CDC BRFSS",
      "contents": [
        {
          "label": "2% - 8.5%",
          "color": "#000052"
        },
        {
          "label": ">8.5% - 9.6%",
          "color": "#3A008C"
        },
        {
          "label": ">9.6% - 10.7%",
          "color": "#7800AB"
        },
        {
          "label": ">10.7% - 12.1%",
          "color": "#BF009F"
        },
        {
          "label": ">12.1% - 45.7%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "DISABILITY",
      "title": "Percentage of adults with any disability",
      "source": "2022 CDC BRFSS",
      "contents": [
        {
          "label": "10.6% - 20.4%",
          "color": "#000052"
        },
        {
          "label": ">20.4% - 23.2%",
          "color": "#3A008C"
        },
        {
          "label": ">23.2% - 26.3%",
          "color": "#7800AB"
        },
        {
          "label": ">26.3% - 30.4%",
          "color": "#BF009F"
        },
        {
          "label": ">30.4% - 70.9%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "home_pre_1960",
      "title": "Percentage of homes built before 1960",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 5%",
          "color": "#000052"
        },
        {
          "label": ">5% - 20%",
          "color": "#3A008C"
        },
        {
          "label": ">20% - 41%",
          "color": "#7800AB"
        },
        {
          "label": ">41% - 63%",
          "color": "#BF009F"
        },
        {
          "label": ">63% - 95%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "lang",
      "title": "Percentage of people over 5 years of age who speak English less than \"very well\"",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 6%",
          "color": "#000052"
        },
        {
          "label": ">6% - 11%",
          "color": "#3A008C"
        },
        {
          "label": ">11% - 16%",
          "color": "#7800AB"
        },
        {
          "label": ">16% - 25%",
          "color": "#BF009F"
        },
        {
          "label": ">25% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "low_edu",
      "title": "Percentage of adults with less than a high school diploma",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 3%",
          "color": "#000052"
        },
        {
          "label": ">3% - 6%",
          "color": "#3A008C"
        },
        {
          "label": ">6% - 10%",
          "color": "#7800AB"
        },
        {
          "label": ">10% - 18%",
          "color": "#BF009F"
        },
        {
          "label": ">18% - 91%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "med_inc_60",
      "title": "Tract median income <= 60% county median income",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "at least 60% county-level median income",
          "color": "#000052"
        },
        {
          "label": "under 60% county-level median income",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "multi_unit",
      "title": "Percentage of households within multi unit dwellings",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 7%",
          "color": "#000052"
        },
        {
          "label": ">7% - 21%",
          "color": "#3A008C"
        },
        {
          "label": ">21% - 38%",
          "color": "#7800AB"
        },
        {
          "label": ">38% - 66%",
          "color": "#BF009F"
        },
        {
          "label": ">66% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "perc_impervious",
      "title": "Percentage of tract area categorized as impervious surfaces",
      "source": "2021 USGS NLCD",
      "contents": [
        {
          "label": "0% - 29.8%",
          "color": "#000052"
        },
        {
          "label": ">29.8% - 52%",
          "color": "#3A008C"
        },
        {
          "label": ">52% - 62%",
          "color": "#7800AB"
        },
        {
          "label": ">62% - 71%",
          "color": "#BF009F"
        },
        {
          "label": ">71% - 97%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "perc_tree_canopy",
      "title": "Percentage of tract area categorized as tree canopy",
      "source": "2021 USGS NLCD",
      "contents": [
        {
          "label": ">12% - 65%",
          "color": "#000052"
        },
        {
          "label": ">7% - 12%",
          "color": "#3A008C"
        },
        {
          "label": ">4% - 7%",
          "color": "#7800AB"
        },
        {
          "label": ">2% - 4%",
          "color": "#BF009F"
        },
        {
          "label": "0% - 2%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "P_D2_PM25",
      "title": "Percentile for Particulate Matter 2.5 EJ Index",
      "source": "2024 EPA EJSCREEN",
      "contents": [
        {
          "label": "0% - 16%",
          "color": "#000052"
        },
        {
          "label": ">16% - 25%",
          "color": "#3A008C"
        },
        {
          "label": ">25% - 36%",
          "color": "#7800AB"
        },
        {
          "label": ">36% - 47%",
          "color": "#BF009F"
        },
        {
          "label": ">47% - 80%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "poc",
      "title": "Percentage of population identifying as people of color (non white)",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "6% - 40%",
          "color": "#000052"
        },
        {
          "label": ">40% - 55%",
          "color": "#3A008C"
        },
        {
          "label": ">55% - 70%",
          "color": "#7800AB"
        },
        {
          "label": ">70% - 84%",
          "color": "#BF009F"
        },
        {
          "label": ">84% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "psps",
      "title": "Percentage of tract area within PG&E Public safety power shut off areas",
      "source": "2021 PG&E PSPS",
      "contents": [
        {
          "label": "0% - 7%",
          "color": "#000052"
        },
        {
          "label": ">7% - 27%",
          "color": "#3A008C"
        },
        {
          "label": ">27% - 46%",
          "color": "#7800AB"
        },
        {
          "label": ">46% - 70%",
          "color": "#BF009F"
        },
        {
          "label": ">70% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "P_D2_PTRAF",
      "title": "Percentile for Traffic proximity EJ Index",
      "source": "2024 EPA EJSCREEN",
      "contents": [
        {
          "label": "0% - 26%",
          "color": "#000052"
        },
        {
          "label": ">26% - 43%",
          "color": "#3A008C"
        },
        {
          "label": ">43% - 57%",
          "color": "#7800AB"
        },
        {
          "label": ">57% - 72%",
          "color": "#BF009F"
        },
        {
          "label": ">72% - 99%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "redline",
      "title": "Percentage of tract area within historically redlined areas",
      "source": "2023 University of Richmond DSL",
      "contents": [
        {
          "label": "1% - 6%",
          "color": "#000052"
        },
        {
          "label": ">6% - 25%",
          "color": "#3A008C"
        },
        {
          "label": ">25% - 54%",
          "color": "#7800AB"
        },
        {
          "label": ">54% - 86%",
          "color": "#BF009F"
        },
        {
          "label": ">86% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "renter",
      "title": "Percentage of housing units that are renter-occupied",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "3% - 20%",
          "color": "#000052"
        },
        {
          "label": ">20% - 33%",
          "color": "#3A008C"
        },
        {
          "label": ">33% - 48%",
          "color": "#7800AB"
        },
        {
          "label": ">48% - 67%",
          "color": "#BF009F"
        },
        {
          "label": ">67% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "senior_hh",
      "title": "Percentage of households with older adults (age >= 65 years)",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 21%",
          "color": "#000052"
        },
        {
          "label": ">21% - 28%",
          "color": "#3A008C"
        },
        {
          "label": ">28% - 34%",
          "color": "#7800AB"
        },
        {
          "label": ">34% - 41%",
          "color": "#BF009F"
        },
        {
          "label": ">41% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "SHUTUTILITY",
      "title": "Percentage of househilds which experienced threat of utility services cutoff",
      "source": "2022 CDC BRFSS",
      "contents": [
        {
          "label": "1.2% - 3.3%",
          "color": "#000052"
        },
        {
          "label": ">3.3% - 4.2%",
          "color": "#3A008C"
        },
        {
          "label": ">4.2% - 5.4%",
          "color": "#7800AB"
        },
        {
          "label": ">5.4% - 7.2%",
          "color": "#BF009F"
        },
        {
          "label": ">7.2% - 21.6%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "single_hohh_dep",
      "title": "Percentage of households where head is single and living with dependents",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 7%",
          "color": "#000052"
        },
        {
          "label": ">7% - 10%",
          "color": "#3A008C"
        },
        {
          "label": ">10% - 14%",
          "color": "#7800AB"
        },
        {
          "label": ">14% - 19%",
          "color": "#BF009F"
        },
        {
          "label": ">19% - 53%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "unemp",
      "title": "Percentage of civilian labor force experiencing unemployment",
      "source": "2022 USCB ACS5",
      "contents": [
        {
          "label": "0% - 3%",
          "color": "#000052"
        },
        {
          "label": ">3% - 4%",
          "color": "#3A008C"
        },
        {
          "label": ">4% - 5%",
          "color": "#7800AB"
        },
        {
          "label": ">5% - 7%",
          "color": "#BF009F"
        },
        {
          "label": ">7% - 26%",
          "color": "#FF0080"
        }
      ]
    }
  ]
};
