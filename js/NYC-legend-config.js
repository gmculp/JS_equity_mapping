const legend_specs = {
  "legends": [
    {
      "var_name": "all_all",
      "title": "Index of variables that likely contribute to energy insecurity/energy burden",
      "source": "2023 USCB ACS5, 2022 CDC BRFSS, 2021 MRLC NLCD, 2023 EPA EJSCREEN, 2021 PG&E PSPS, 2023 University of Richmond DSL",
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
      "source": "2021 MRLC NLCD, 2023 EPA EJSCREEN, 2021 PG&E PSPS, 2023 University of Richmond DSL",
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
      "source": "2023 USCB ACS5",
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
      "source": "2023 USCB ACS5",
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
          "label": "0.9% - 4.2%",
          "color": "#000052"
        },
        {
          "label": ">4.2% - 4.8%",
          "color": "#3A008C"
        },
        {
          "label": ">4.8% - 5.6%",
          "color": "#7800AB"
        },
        {
          "label": ">5.6% - 7.1%",
          "color": "#BF009F"
        },
        {
          "label": ">7.1% - 22%",
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
          "label": "6.3% - 8.6%",
          "color": "#000052"
        },
        {
          "label": ">8.6% - 9.5%",
          "color": "#3A008C"
        },
        {
          "label": ">9.5% - 10.5%",
          "color": "#7800AB"
        },
        {
          "label": ">10.5% - 11.8%",
          "color": "#BF009F"
        },
        {
          "label": ">11.8% - 16.6%",
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
          "label": "0.9% - 4.8%",
          "color": "#000052"
        },
        {
          "label": ">4.8% - 5.6%",
          "color": "#3A008C"
        },
        {
          "label": ">5.6% - 6.1%",
          "color": "#7800AB"
        },
        {
          "label": ">6.1% - 6.9%",
          "color": "#BF009F"
        },
        {
          "label": ">6.9% - 37.1%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "child_hh",
      "title": "Percentage of households with young children (age <= 5 years)",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 2%",
          "color": "#000052"
        },
        {
          "label": ">2% - 4%",
          "color": "#3A008C"
        },
        {
          "label": ">4% - 5%",
          "color": "#7800AB"
        },
        {
          "label": ">5% - 8%",
          "color": "#BF009F"
        },
        {
          "label": ">8% - 68%",
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
          "label": "1% - 4%",
          "color": "#000052"
        },
        {
          "label": ">4% - 4.9%",
          "color": "#3A008C"
        },
        {
          "label": ">4.9% - 5.7%",
          "color": "#7800AB"
        },
        {
          "label": ">5.7% - 6.8%",
          "color": "#BF009F"
        },
        {
          "label": ">6.8% - 25.2%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "cost_burden_50",
      "title": "Percentage of households where housing costs exceed 50% of household income",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 16%",
          "color": "#000052"
        },
        {
          "label": ">16% - 21%",
          "color": "#3A008C"
        },
        {
          "label": ">21% - 26%",
          "color": "#7800AB"
        },
        {
          "label": ">26% - 32%",
          "color": "#BF009F"
        },
        {
          "label": ">32% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "crowd",
      "title": "Percentage of household with more than one occupants per room",
      "source": "2023 USCB ACS5",
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
          "label": ">6% - 9%",
          "color": "#7800AB"
        },
        {
          "label": ">9% - 15%",
          "color": "#BF009F"
        },
        {
          "label": ">15% - 100%",
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
          "label": "1.7% - 8.7%",
          "color": "#000052"
        },
        {
          "label": ">8.7% - 11%",
          "color": "#3A008C"
        },
        {
          "label": ">11% - 12.7%",
          "color": "#7800AB"
        },
        {
          "label": ">12.7% - 14.6%",
          "color": "#BF009F"
        },
        {
          "label": ">14.6% - 44.7%",
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
          "label": "12.3% - 23.6%",
          "color": "#000052"
        },
        {
          "label": ">23.6% - 27.5%",
          "color": "#3A008C"
        },
        {
          "label": ">27.5% - 30.8%",
          "color": "#7800AB"
        },
        {
          "label": ">30.8% - 35.7%",
          "color": "#BF009F"
        },
        {
          "label": ">35.7% - 69.5%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "energy_cost",
      "title": "Percentage of income spent on energy costs",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 2%",
          "color": "#000052"
        },
        {
          "label": ">2% - 2%",
          "color": "#3A008C"
        },
        {
          "label": ">2% - 3%",
          "color": "#7800AB"
        },
        {
          "label": ">3% - 4%",
          "color": "#BF009F"
        },
        {
          "label": ">4% - 8%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "home_pre_1960",
      "title": "Percentage of homes built before 1960",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 44%",
          "color": "#000052"
        },
        {
          "label": ">44% - 62%",
          "color": "#3A008C"
        },
        {
          "label": ">62% - 73%",
          "color": "#7800AB"
        },
        {
          "label": ">73% - 83%",
          "color": "#BF009F"
        },
        {
          "label": ">83% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "lang",
      "title": "Percentage of people over 5 years of age who speak English less than 'very well'",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 7%",
          "color": "#000052"
        },
        {
          "label": ">7% - 14%",
          "color": "#3A008C"
        },
        {
          "label": ">14% - 23%",
          "color": "#7800AB"
        },
        {
          "label": ">23% - 35%",
          "color": "#BF009F"
        },
        {
          "label": ">35% - 89%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "low_edu",
      "title": "Percentage of adults with less than a high school diploma",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 7%",
          "color": "#000052"
        },
        {
          "label": ">7% - 12%",
          "color": "#3A008C"
        },
        {
          "label": ">12% - 18%",
          "color": "#7800AB"
        },
        {
          "label": ">18% - 26%",
          "color": "#BF009F"
        },
        {
          "label": ">26% - 70%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "med_inc_60",
      "title": "Tract median income <= 60% county median income",
      "source": "2023 USCB ACS5",
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
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 54%",
          "color": "#000052"
        },
        {
          "label": ">54% - 81%",
          "color": "#3A008C"
        },
        {
          "label": ">81% - 92%",
          "color": "#7800AB"
        },
        {
          "label": ">92% - 98%",
          "color": "#BF009F"
        },
        {
          "label": ">98% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "P_D2_PM25",
      "title": "Percentile for Particulate Matter 2.5 EJ Index",
      "source": "2023 EPA EJSCREEN",
      "contents": [
        {
          "label": "0% - 59%",
          "color": "#000052"
        },
        {
          "label": ">59% - 70%",
          "color": "#3A008C"
        },
        {
          "label": ">70% - 81%",
          "color": "#7800AB"
        },
        {
          "label": ">81% - 91%",
          "color": "#BF009F"
        },
        {
          "label": ">91% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "P_D2_PTRAF",
      "title": "Percentile for Traffic proximity EJ Index",
      "source": "2023 EPA EJSCREEN",
      "contents": [
        {
          "label": "0% - 58%",
          "color": "#000052"
        },
        {
          "label": ">58% - 70.4%",
          "color": "#3A008C"
        },
        {
          "label": ">70.4% - 81%",
          "color": "#7800AB"
        },
        {
          "label": ">81% - 91%",
          "color": "#BF009F"
        },
        {
          "label": ">91% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "perc_impervious",
      "title": "Percentage of tract area categorized as impervious surfaces",
      "source": "2021 MRLC NLCD",
      "contents": [
        {
          "label": "8.5% - 74.7%",
          "color": "#000052"
        },
        {
          "label": ">74.7% - 83.5%",
          "color": "#3A008C"
        },
        {
          "label": ">83.5% - 88.7%",
          "color": "#7800AB"
        },
        {
          "label": ">88.7% - 92.9%",
          "color": "#BF009F"
        },
        {
          "label": ">92.9% - 111.9%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "perc_tree_canopy",
      "title": "Percentage of tract area categorized as tree canopy",
      "source": "2021 MRLC NLCD",
      "contents": [
        {
          "label": "0% - 0.5%",
          "color": "#000052"
        },
        {
          "label": ">0.5% - 1.5%",
          "color": "#3A008C"
        },
        {
          "label": ">1.5% - 3.6%",
          "color": "#7800AB"
        },
        {
          "label": ">3.6% - 8.9%",
          "color": "#BF009F"
        },
        {
          "label": ">8.9% - 63.7%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "poc",
      "title": "Percentage of population identifying as people of color (non white)",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 40%",
          "color": "#000052"
        },
        {
          "label": ">40% - 64%",
          "color": "#3A008C"
        },
        {
          "label": ">64% - 87%",
          "color": "#7800AB"
        },
        {
          "label": ">87% - 97%",
          "color": "#BF009F"
        },
        {
          "label": ">97% - 100%",
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
          "label": "0% - 20%",
          "color": "#000052"
        },
        {
          "label": ">20% - 40%",
          "color": "#3A008C"
        },
        {
          "label": ">40% - 60%",
          "color": "#7800AB"
        },
        {
          "label": ">60% - 80%",
          "color": "#BF009F"
        },
        {
          "label": ">80% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "renter",
      "title": "Percentage of housing units that are renter-occupied",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 38%",
          "color": "#000052"
        },
        {
          "label": ">38% - 57%",
          "color": "#3A008C"
        },
        {
          "label": ">57% - 74%",
          "color": "#7800AB"
        },
        {
          "label": ">74% - 88%",
          "color": "#BF009F"
        },
        {
          "label": ">88% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "senior_hh",
      "title": "Percentage of households with older adults (age >= 65 years)",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 22%",
          "color": "#000052"
        },
        {
          "label": ">22% - 29%",
          "color": "#3A008C"
        },
        {
          "label": ">29% - 35%",
          "color": "#7800AB"
        },
        {
          "label": ">35% - 43%",
          "color": "#BF009F"
        },
        {
          "label": ">43% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "single_hohh_dep",
      "title": "Percentage of households where head is single and living with dependents",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 9%",
          "color": "#000052"
        },
        {
          "label": ">9% - 16%",
          "color": "#3A008C"
        },
        {
          "label": ">16% - 24%",
          "color": "#7800AB"
        },
        {
          "label": ">24% - 32%",
          "color": "#BF009F"
        },
        {
          "label": ">32% - 100%",
          "color": "#FF0080"
        }
      ]
    },
    {
      "var_name": "unemp",
      "title": "Percentage of civilian labor force experiencing unemployment",
      "source": "2023 USCB ACS5",
      "contents": [
        {
          "label": "0% - 4%",
          "color": "#000052"
        },
        {
          "label": ">4% - 6%",
          "color": "#3A008C"
        },
        {
          "label": ">6% - 8%",
          "color": "#7800AB"
        },
        {
          "label": ">8% - 11%",
          "color": "#BF009F"
        },
        {
          "label": ">11% - 100%",
          "color": "#FF0080"
        }
      ]
    }
  ]
};
