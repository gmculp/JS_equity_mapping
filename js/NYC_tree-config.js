var baseTree = 
  {
    label: "Electrification Equity Index",
    name: "all_all",
    children: [
      {
        label: "Environmental Variables",
        name: "all_environmental",
        children: [
          {
            label: "PM 2.5",
            name: "P_D2_PM25"
          },
          {
            label: "Traffic Proximity",
            name: "P_D2_PTRAF"
          },
          {
            label: "Impervious Surfaces",
            name: "perc_impervious"
          },
          {
            label: "Tree Canopy",
            name: "perc_tree_canopy"
          },
          {
            label: "Redlined Areas",
            name: "redline"
          }
        ]
      },
      {
        label: "Health & Disability Variables",
        name: "all_health_dis",
        children: [
          {
            label: "Cancer",
            name: "CANCER"
          },
          {
            label: "Asthma",
            name: "CASTHMA"
          },
          {
            label: "Heart Disease",
            name: "CHD"
          },
          {
            label: "COPD",
            name: "COPD"
          },
          {
            label: "Diabetes",
            name: "DIABETES"
          },
          {
            label: "Disability",
            name: "DISABILITY"
          }
        ]
      },
      {
        label: "Housing & Energy Variables",
        name: "all_house_energy",
        children: [
          {
            label: "Housing Cost Burden",
            name: "cost_burden_50"
          },
          {
            label: "Crowding",
            name: "crowd"
          },
          {
            label: "Energy Cost",
            name: "energy_cost"
          },
          {
            label: "Older Homes",
            name: "home_pre_1960"
          },
          {
            label: "Multi Unit Dwellings",
            name: "multi_unit"
          },
          {
            label: "Renters",
            name: "renter"
          },
          {
            label: "Single HoH",
            name: "single_hohh_dep"
          }
        ]
      },
      {
        label: "Sociodemographic Variables",
        name: "all_soc_dem",
        children: [
          {
            label: "Young Children",
            name: "child_hh"
          },
          {
            label: "Linguistic Isolation",
            name: "lang"
          },
          {
            label: "Limited Education",
            name: "low_edu"
          },
          {
            label: "Low Median Income",
            name: "med_inc_60"
          },
          {
            label: "People of Color",
            name: "poc"
          },
          {
            label: "Older Adults",
            name: "senior_hh"
          },
          {
            label: "Unemployment",
            name: "unemp"
          }
        ]
      }
    ]
  };
