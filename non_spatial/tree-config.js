var baseTree = {
    label: 'HEEP Variables',
	name: 'all_all',
    children: [
        {
            label: 'Environmental Variables',
			name: 'all_environmental',
            children: [
                { label: 'Impervious Surfaces', name: 'perc_impervious' },
                { label: 'PM 2.5', name: 'PM25' },
				{ label: 'PSPS Areas', name: 'psps' },
				{ label: 'Redlined Areas', name: 'redline' },
				{ label: 'Traffic Proximity', name: 'PTRAF' },
				{ label: 'Tree Canopy', name: 'perc_tree_canopy' }
            ]
        },
        {
            label: 'Health & Disability Variables',
			name: 'all_health_dis',
            children: [
				{ label: 'Asthma', name: 'CASTHMA' },
                { label: 'Cancer', name: 'CANCER' },
				{ label: 'COPD', name: 'COPD' },
				{ label: 'Diabetes', name: 'DIABETES' },
				{ label: 'Disability', name: 'DISABILITY' },
				{ label: 'Heart Disease', name: 'CHD' }	
            ]
        },
		{
            label: 'Housing & Energy Variables',
			name: 'all_house_energy',
            children: [
				{ label: 'Crowding', name: 'crowd' },
				{ label: 'Housing Cost Burden', name: 'cost_burden_50' },
				{ label: 'Multi Unit Dwellings', name: 'multi_unit' },
				{ label: 'Older Homes', name: 'home_pre_1960' },
				{ label: 'Renters', name: 'renter' },
				{ label: 'Single HoH', name: 'single_hohh_dep' },
				{ label: 'Utility Insecurity', name: 'SHUTUTILITY' }	
            ]
        },
		{
            label: 'Sociodemographic Variables',
			name: 'all_soc_dem',
            children: [
				{ label: 'Limited Education', name: 'low_edu' },
				{ label: 'Linguistic Isolation', name: 'lang' },
				{ label: 'Low Median Income', name: 'med_inc_60' },
				{ label: 'Older Adults', name: 'senior_hh' },
				{ label: 'People of color', name: 'poc' },
				{ label: 'Unemployment', name: 'unemp' },	
				{ label: 'Young Children', name: 'child_hh' }
            ]
        }
    ]
};