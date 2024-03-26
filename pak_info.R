# Check if tidyverse is installed, if not install it
if (!requireNamespace("tidyverse", quietly = TRUE)){install.packages(tidyverse)}
# Load the tidyverse package
library(tidyverse)
# Access some functions from the tidyverse package
# For example, use the ggplot() function
ggplot(mtcars, aes(x = mpg, y = disp)) + geom_point()
# Get help documentation for a function in the tidyverse package
?ggplot