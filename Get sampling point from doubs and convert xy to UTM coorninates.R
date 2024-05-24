# 安装并加载所需的包
if(!require("sf")) install.packages("sf")
if(!require("ade4")) install.packages("ade4")

library(sf)
library(ade4)

# 加载doubs数据集
data("doubs", package = "ade4")

# 提取xy数据
xy_data <- doubs$xy

# 创建sf对象，假设原始坐标系为WGS84 (EPSG:4326)
# 由于未明确提供doubs数据集中的坐标系统，因此假设它是WGS84
xy_sf <- st_as_sf(xy_data, coords = c("x", "y"), crs = 4326) 

# 转换为UTM 32T (EPSG:32632)
xy_utm <- st_transform(xy_sf, crs = 32632)  # 使用EPSG代码指定UTM区域

# 保存结果到CSV文件
st_write(xy_utm, "doubs_utm.csv", delete_dsn = TRUE)  # 删除现有文件以避免错误

# 将sf对象转换为数据框，然后写入CSV
xy_utm_df <- as.data.frame(st_coordinates(xy_utm))
write.csv(xy_utm_df, "doubs_utm.csv", row.names = FALSE)

#
head(xy_utm_df)