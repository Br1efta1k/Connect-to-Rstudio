# 安装并加载必要的R包
if (!requireNamespace("ade4", quietly = TRUE)) {
  install.packages("ade4")
}

if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}

library(ade4)
library(tidyverse)

# 查看doubs数据集包含哪些数据
data("doubs")
ls(pattern = "doubs")

# doubs数据集中包含以下数据：
# - doubs$fish：站点与鱼的存在/不存在数据
# - doubs$env：站点与环境变量
# - doubs$xy：站点的地理坐标
# - doubs$spe：站点与鱼种类的数量

# 我们将这些数据整合到一个数据框中
# 首先，转化鱼的存在/不存在数据
fish_df <- as.data.frame(doubs$fish)
fish_df <- rownames_to_column(fish_df, "site")  # 加入站点列

# 转化环境变量数据
env_df <- as.data.frame(doubs$env)
env_df <- rownames_to_column(env_df, "site")  # 加入站点列

# 转化地理坐标数据
xy_df <- as.data.frame(doubs$xy)
xy_df <- rownames_to_column(xy_df, "site")  # 加入站点列

# 合并数据
final_df <- fish_df %>%
  left_join(env_df, by = "site") %>%
  left_join(xy_df, by = "site")

# 查看最终合并的数据框
head(final_df)

# 导出为CSV文件
output_file_path <- "doubs_combined.csv"  # 指定文件名

# 将数据框写入CSV文件
write.csv(final_df, file = output_file_path, row.names = FALSE)

# 输出结果
cat("数据已导出为CSV文件：", output_file_path, "\n")
