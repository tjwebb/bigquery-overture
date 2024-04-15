select
  * except(geometry),
  st_geogFromWKB(geometry) as geometry
from `project.dataset.theme_stage`
