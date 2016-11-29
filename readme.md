# Open Address Census

This is a tiny experiment with swift that calculates the current US population coverage of [OpenAddresses](https://github.com/openaddresses/openaddresses/).

## How it works

This combines census data and OpenAddresses sources to calculate population coverage in the US. Some sources in OpenAddresses have a [geoid](https://www.census.gov/geo/reference/geoidentifiers.html) property that can be used to look up [population](https://www.census.gov/popest/data/index.html).

For now we use county level population data. Although many sources are county level some are state or places (like cities). We account for state level because of the easy hierarchical nature of a geoid. We right now don't account for city level or possible overlap with county areas. 

[Results](Results/Result.markdown)

### Caveats

Since this doesn't support cities we are leaving out some big places like New York City. I've added a [exclude.txt](Data/Exclude.txt) file to mark these as already included in the sources. This is not an exhaustive list but has some of the larger counties that have sources.

## Usage

### Census county populations

```bash
swift build && .build/debug/OpenAddressesCensus ./Data/PEP_2015_PEPANNRES_with_ann.csv [Path to open address git directory] ./Data/exclude.txt
```

## Future work
- Support for places like cities
- Calculate population from polygons to support overlapping areas
