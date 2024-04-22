select
  * except(geometry),
  st_geogFromWKB(geometry, make_valid => true) as geometry
from `project.dataset.theme_stage`
