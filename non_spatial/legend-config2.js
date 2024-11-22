const legend_specs = {
  "legends": [
    [
      {
        "group_title": "All Variables",
        "children": [
          {
            "var_name": "all_all",
            "toc": "All Variables",
            "title": "All variables",
            "contents": [
              {
                "label": "very low vulnerability",
                "color": "#400000"
              },
              {
                "label": "low vulnerability",
                "color": "#690000"
              },
              {
                "label": "moderate vulnerability",
                "color": "#970000"
              },
              {
                "label": "high vulnerability",
                "color": "#C90000"
              },
              {
                "label": "very high vulnerability",
                "color": "#FF0000"
              }
            ]
          }
        ]
      },
      {
        "group_title": "Environmental Variables",
        "children": [
          {
            "var_name": "all_environmental",
            "toc": "All Environmental",
            "title": "All environmental variables",
            "contents": [
              {
                "label": "very low vulnerability",
                "color": "#334000"
              },
              {
                "label": "low vulnerability",
                "color": "#546900"
              },
              {
                "label": "moderate vulnerability",
                "color": "#799700"
              },
              {
                "label": "high vulnerability",
                "color": "#A1C900"
              },
              {
                "label": "very high vulnerability",
                "color": "#CCFF00"
              }
            ]
          },
          {
            "var_name": "perc_impervious",
            "toc": "Impervious Surfaces",
            "title": "Impervious surfaces",
            "contents": [
              {
                "label": "0% - 29.8%",
                "color": "#334000"
              },
              {
                "label": ">29.8% - 52%",
                "color": "#546900"
              },
              {
                "label": ">52% - 62%",
                "color": "#799700"
              },
              {
                "label": ">62% - 71%",
                "color": "#A1C900"
              },
              {
                "label": ">71% - 97%",
                "color": "#CCFF00"
              }
            ]
          },
          {
            "var_name": "perc_tree_canopy",
            "toc": "Tree Canopy",
            "title": "Tree canopy",
            "contents": [
              {
                "label": ">12% - 65%",
                "color": "#334000"
              },
              {
                "label": ">7% - 12%",
                "color": "#546900"
              },
              {
                "label": ">4% - 7%",
                "color": "#799700"
              },
              {
                "label": ">2% - 4%",
                "color": "#A1C900"
              },
              {
                "label": "0% - 2%",
                "color": "#CCFF00"
              }
            ]
          },
          {
            "var_name": "PM25",
            "toc": "PM 2.5",
            "title": "PM 2.5",
            "contents": [
              {
                "label": "7.53% - 9.91%",
                "color": "#334000"
              },
              {
                "label": ">9.91% - 10.58%",
                "color": "#546900"
              },
              {
                "label": ">10.58% - 11.2%",
                "color": "#799700"
              },
              {
                "label": ">11.2% - 11.43%",
                "color": "#A1C900"
              },
              {
                "label": ">11.43% - 13.04%",
                "color": "#CCFF00"
              }
            ]
          },
          {
            "var_name": "psps",
            "toc": "PSPS Areas",
            "title": "Public safety power shutoff areas",
            "contents": [
              {
                "label": "0% - 7%",
                "color": "#334000"
              },
              {
                "label": ">7% - 27%",
                "color": "#546900"
              },
              {
                "label": ">27% - 46%",
                "color": "#799700"
              },
              {
                "label": ">46% - 70%",
                "color": "#A1C900"
              },
              {
                "label": ">70% - 100%",
                "color": "#CCFF00"
              }
            ]
          },
          {
            "var_name": "PTRAF",
            "toc": "Traffic Proximity",
            "title": "Traffic proximity",
            "contents": [
              {
                "label": "0.0M - 1.8M",
                "color": "#334000"
              },
              {
                "label": ">1.8M - 2.9M",
                "color": "#546900"
              },
              {
                "label": ">2.9M - 4.3M",
                "color": "#799700"
              },
              {
                "label": ">4.3M - 6.0M",
                "color": "#A1C900"
              },
              {
                "label": ">6.0M - 14.1M",
                "color": "#CCFF00"
              }
            ]
          },
          {
            "var_name": "redline",
            "toc": "Redlined Areas",
            "title": "Redlined areas",
            "contents": [
              {
                "label": "1% - 6%",
                "color": "#334000"
              },
              {
                "label": ">6% - 25%",
                "color": "#546900"
              },
              {
                "label": ">25% - 54%",
                "color": "#799700"
              },
              {
                "label": ">54% - 86%",
                "color": "#A1C900"
              },
              {
                "label": ">86% - 100%",
                "color": "#CCFF00"
              }
            ]
          }
        ]
      },
      {
        "group_title": "Health & Disability Variables",
        "children": [
          {
            "var_name": "all_health_dis",
            "toc": "All Health & Disability",
            "title": "All health and disability variables",
            "contents": [
              {
                "label": "very low vulnerability",
                "color": "#00401A"
              },
              {
                "label": "low vulnerability",
                "color": "#00692A"
              },
              {
                "label": "moderate vulnerability",
                "color": "#00973C"
              },
              {
                "label": "high vulnerability",
                "color": "#00C950"
              },
              {
                "label": "very high vulnerability",
                "color": "#00FF66"
              }
            ]
          },
          {
            "var_name": "CANCER",
            "toc": "Cancer",
            "title": "Cancer (non-skin) or melanoma among adults",
            "contents": [
              {
                "label": "1% - 4.8%",
                "color": "#00401A"
              },
              {
                "label": ">4.8% - 5.8%",
                "color": "#00692A"
              },
              {
                "label": ">5.8% - 7%",
                "color": "#00973C"
              },
              {
                "label": ">7% - 9%",
                "color": "#00C950"
              },
              {
                "label": ">9% - 23.1%",
                "color": "#00FF66"
              }
            ]
          },
          {
            "var_name": "CASTHMA",
            "toc": "Asthma",
            "title": "Current asthma among adults",
            "contents": [
              {
                "label": "5.9% - 8.3%",
                "color": "#00401A"
              },
              {
                "label": ">8.3% - 9%",
                "color": "#00692A"
              },
              {
                "label": ">9% - 9.6%",
                "color": "#00973C"
              },
              {
                "label": ">9.6% - 10.3%",
                "color": "#00C950"
              },
              {
                "label": ">10.3% - 14.1%",
                "color": "#00FF66"
              }
            ]
          },
          {
            "var_name": "CHD",
            "toc": "CHD",
            "title": "Coronary heart disease among adults",
            "contents": [
              {
                "label": "1% - 4.2%",
                "color": "#00401A"
              },
              {
                "label": ">4.2% - 4.9%",
                "color": "#00692A"
              },
              {
                "label": ">4.9% - 5.4%",
                "color": "#00973C"
              },
              {
                "label": ">5.4% - 6.1%",
                "color": "#00C950"
              },
              {
                "label": ">6.1% - 28.9%",
                "color": "#00FF66"
              }
            ]
          },
          {
            "var_name": "COPD",
            "toc": "COPD",
            "title": "Chronic obstructive pulmonary disease among adults",
            "contents": [
              {
                "label": "0.9% - 3.4%",
                "color": "#00401A"
              },
              {
                "label": ">3.4% - 4.1%",
                "color": "#00692A"
              },
              {
                "label": ">4.1% - 4.8%",
                "color": "#00973C"
              },
              {
                "label": ">4.8% - 5.7%",
                "color": "#00C950"
              },
              {
                "label": ">5.7% - 19.7%",
                "color": "#00FF66"
              }
            ]
          },
          {
            "var_name": "DIABETES",
            "toc": "Diabetes",
            "title": "Diagnosed diabetes among adults",
            "contents": [
              {
                "label": "2% - 8.5%",
                "color": "#00401A"
              },
              {
                "label": ">8.5% - 9.6%",
                "color": "#00692A"
              },
              {
                "label": ">9.6% - 10.7%",
                "color": "#00973C"
              },
              {
                "label": ">10.7% - 12.1%",
                "color": "#00C950"
              },
              {
                "label": ">12.1% - 45.7%",
                "color": "#00FF66"
              }
            ]
          },
          {
            "var_name": "DISABILITY",
            "toc": "Any Disability",
            "title": "Any disability among adults",
            "contents": [
              {
                "label": "10.6% - 20.4%",
                "color": "#00401A"
              },
              {
                "label": ">20.4% - 23.2%",
                "color": "#00692A"
              },
              {
                "label": ">23.2% - 26.3%",
                "color": "#00973C"
              },
              {
                "label": ">26.3% - 30.4%",
                "color": "#00C950"
              },
              {
                "label": ">30.4% - 70.9%",
                "color": "#00FF66"
              }
            ]
          }
        ]
      },
      {
        "group_title": "Housing & Energy Variables",
        "children": [
          {
            "var_name": "all_house_energy",
            "toc": "All Housing & Energy",
            "title": "All housing and energy variables",
            "contents": [
              {
                "label": "very low vulnerability",
                "color": "#001A40"
              },
              {
                "label": "low vulnerability",
                "color": "#002A69"
              },
              {
                "label": "moderate vulnerability",
                "color": "#003C97"
              },
              {
                "label": "high vulnerability",
                "color": "#0050C9"
              },
              {
                "label": "very high vulnerability",
                "color": "#0066FF"
              }
            ]
          },
          {
            "var_name": "cost_burden_50",
            "toc": "High Housing Costs",
            "title": "Housing costs > 50% of household income",
            "contents": [
              {
                "label": "0% - 10%",
                "color": "#001A40"
              },
              {
                "label": ">10% - 14%",
                "color": "#002A69"
              },
              {
                "label": ">14% - 17%",
                "color": "#003C97"
              },
              {
                "label": ">17% - 22%",
                "color": "#0050C9"
              },
              {
                "label": ">22% - 82%",
                "color": "#0066FF"
              }
            ]
          },
          {
            "var_name": "crowd",
            "toc": "Crowding",
            "title": "Occupants per room > 1 person",
            "contents": [
              {
                "label": "0% - 1%",
                "color": "#001A40"
              },
              {
                "label": ">1% - 4%",
                "color": "#002A69"
              },
              {
                "label": ">4% - 7%",
                "color": "#003C97"
              },
              {
                "label": ">7% - 12%",
                "color": "#0050C9"
              },
              {
                "label": ">12% - 70%",
                "color": "#0066FF"
              }
            ]
          },
          {
            "var_name": "home_pre_1960",
            "toc": "Older Homes",
            "title": "Home built before 1960",
            "contents": [
              {
                "label": "0% - 5%",
                "color": "#001A40"
              },
              {
                "label": ">5% - 20%",
                "color": "#002A69"
              },
              {
                "label": ">20% - 41%",
                "color": "#003C97"
              },
              {
                "label": ">41% - 63%",
                "color": "#0050C9"
              },
              {
                "label": ">63% - 95%",
                "color": "#0066FF"
              }
            ]
          },
          {
            "var_name": "multi_unit",
            "toc": "Multi Unit Dwellings",
            "title": "Households in multi unit dwellings",
            "contents": [
              {
                "label": "0% - 7%",
                "color": "#001A40"
              },
              {
                "label": ">7% - 21%",
                "color": "#002A69"
              },
              {
                "label": ">21% - 38%",
                "color": "#003C97"
              },
              {
                "label": ">38% - 66%",
                "color": "#0050C9"
              },
              {
                "label": ">66% - 100%",
                "color": "#0066FF"
              }
            ]
          },
          {
            "var_name": "renter",
            "toc": "Renters",
            "title": "Renter-occupied housing units",
            "contents": [
              {
                "label": "3% - 20%",
                "color": "#001A40"
              },
              {
                "label": ">20% - 33%",
                "color": "#002A69"
              },
              {
                "label": ">33% - 48%",
                "color": "#003C97"
              },
              {
                "label": ">48% - 67%",
                "color": "#0050C9"
              },
              {
                "label": ">67% - 100%",
                "color": "#0066FF"
              }
            ]
          },
          {
            "var_name": "SHUTUTILITY",
            "toc": "Utility Insecurity",
            "title": "Threat of utility services cutoff",
            "contents": [
              {
                "label": "1.2% - 3.3%",
                "color": "#001A40"
              },
              {
                "label": ">3.3% - 4.2%",
                "color": "#002A69"
              },
              {
                "label": ">4.2% - 5.4%",
                "color": "#003C97"
              },
              {
                "label": ">5.4% - 7.2%",
                "color": "#0050C9"
              },
              {
                "label": ">7.2% - 21.6%",
                "color": "#0066FF"
              }
            ]
          },
          {
            "var_name": "single_hohh_dep",
            "toc": "Single HoH",
            "title": "Single head of household living with dependents",
            "contents": [
              {
                "label": "0% - 7%",
                "color": "#001A40"
              },
              {
                "label": ">7% - 10%",
                "color": "#002A69"
              },
              {
                "label": ">10% - 14%",
                "color": "#003C97"
              },
              {
                "label": ">14% - 19%",
                "color": "#0050C9"
              },
              {
                "label": ">19% - 53%",
                "color": "#0066FF"
              }
            ]
          }
        ]
      },
      {
        "group_title": "Sociodemographic Variables",
        "children": [
          {
            "var_name": "all_soc_dem",
            "toc": "All Sociodemographic",
            "title": "All sociodemographic variables",
            "contents": [
              {
                "label": "very low vulnerability",
                "color": "#330040"
              },
              {
                "label": "low vulnerability",
                "color": "#540069"
              },
              {
                "label": "moderate vulnerability",
                "color": "#790097"
              },
              {
                "label": "high vulnerability",
                "color": "#A100C9"
              },
              {
                "label": "very high vulnerability",
                "color": "#CC00FF"
              }
            ]
          },
          {
            "var_name": "child_hh",
            "toc": "Young Children",
            "title": "Households with young children (age <= 5 years)",
            "contents": [
              {
                "label": "0% - 3%",
                "color": "#330040"
              },
              {
                "label": ">3% - 5%",
                "color": "#540069"
              },
              {
                "label": ">5% - 7%",
                "color": "#790097"
              },
              {
                "label": ">7% - 9%",
                "color": "#A100C9"
              },
              {
                "label": ">9% - 41%",
                "color": "#CC00FF"
              }
            ]
          },
          {
            "var_name": "lang",
            "toc": "Linguistic Isolation",
            "title": "People who speak English less than \"very well\"",
            "contents": [
              {
                "label": "0% - 6%",
                "color": "#330040"
              },
              {
                "label": ">6% - 11%",
                "color": "#540069"
              },
              {
                "label": ">11% - 16%",
                "color": "#790097"
              },
              {
                "label": ">16% - 25%",
                "color": "#A100C9"
              },
              {
                "label": ">25% - 100%",
                "color": "#CC00FF"
              }
            ]
          },
          {
            "var_name": "low_edu",
            "toc": "Limited Education",
            "title": "Adults with less than a high school diploma",
            "contents": [
              {
                "label": "0% - 3%",
                "color": "#330040"
              },
              {
                "label": ">3% - 6%",
                "color": "#540069"
              },
              {
                "label": ">6% - 10%",
                "color": "#790097"
              },
              {
                "label": ">10% - 18%",
                "color": "#A100C9"
              },
              {
                "label": ">18% - 91%",
                "color": "#CC00FF"
              }
            ]
          },
          {
            "var_name": "med_inc_60",
            "toc": "Median Income",
            "title": "Tract median income <= 60% county median income",
            "contents": [
              {
                "label": "at least 60% county-level median income",
                "color": "#330040"
              },
              {
                "label": "under 60% county-level median income",
                "color": "#CC00FF"
              }
            ]
          },
          {
            "var_name": "poc",
            "toc": "PoC",
            "title": "People of color",
            "contents": [
              {
                "label": "6% - 40%",
                "color": "#330040"
              },
              {
                "label": ">40% - 55%",
                "color": "#540069"
              },
              {
                "label": ">55% - 70%",
                "color": "#790097"
              },
              {
                "label": ">70% - 84%",
                "color": "#A100C9"
              },
              {
                "label": ">84% - 100%",
                "color": "#CC00FF"
              }
            ]
          },
          {
            "var_name": "senior_hh",
            "toc": "Seniors",
            "title": "Households with seniors (age >= 65 years)",
            "contents": [
              {
                "label": "0% - 21%",
                "color": "#330040"
              },
              {
                "label": ">21% - 28%",
                "color": "#540069"
              },
              {
                "label": ">28% - 34%",
                "color": "#790097"
              },
              {
                "label": ">34% - 41%",
                "color": "#A100C9"
              },
              {
                "label": ">41% - 100%",
                "color": "#CC00FF"
              }
            ]
          },
          {
            "var_name": "unemp",
            "toc": "Unemployment",
            "title": "Unemployed civilian labor force",
            "contents": [
              {
                "label": "0% - 3%",
                "color": "#330040"
              },
              {
                "label": ">3% - 4%",
                "color": "#540069"
              },
              {
                "label": ">4% - 5%",
                "color": "#790097"
              },
              {
                "label": ">5% - 7%",
                "color": "#A100C9"
              },
              {
                "label": ">7% - 26%",
                "color": "#CC00FF"
              }
            ]
          }
        ]
      }
    ]
  ]
};
