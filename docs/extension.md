# Extension Proposal

One shortcoming of our project was the manual dependency management. For example ```model-service``` uses ```scikit-learn``` in requirements.txt, but ```model-training``` uses ```scikit_learn==1.6.1```. This can result in a mismatch across various libraries[1]. Another shortcoming is that despite the individual unit tests and CI pipelines, there is no integration testing to validate full-stack service interoperability before deployment[1]. The extension proposal will focus on the former, although both are significant shortcomings of the project.

## Impact
Although we are unlikely to encounter significant issues with the manual dependency in a short-time span, it can definitely cause further issues down the line. This is because this approach undermines reproducibility, and can cause different behaviours across branches due to the differences in version. It can also lead to integration failures due to unnoticed API or behavior changes, and increase debugging times in the case that errors do occur as a result of any unnoticed changes. These issues become more severe as the scale of the project grows and more dependencies are added.

Furthermore, manual management is a burden on contributors who need to manually inspect versions across branches. This makes the project more prone to various errors and slows down the development process. As with the previous issue, this is likely to compound over time.

## Solution
One way to deal with this is to use ```poetry```[2] to manage dependencies in a more structured and reproducible way, with version locking and environment isolation. Poetry is a tool for dependency management and packaging in Python. To apply ```poetry``` effectively across the project, we propose managing all dependencies through Poetry’s resolution mechanism. This allows us to define shared dependencies with consistent versions across branches. We can also introduce a CI step to verify such consistencies.

## Confirming Improvement
In order to confirm whether using ```poetry``` is an improvement, we can run an empirical expirement. We compare the state of the project before and after adopting it, and observe the following:
- Errors due to dependency mismatch
- Setup ease for developers
  
 Based on these we can validate if the proposed solution is desirable.



[1]: M. Shahin, M. Ali Babar and L. Zhu, "Continuous Integration, Delivery and Deployment: A Systematic Review on Approaches, Tools, Challenges and Practices," in IEEE Access, vol. 5, pp. 3909-3943, 2017, doi: 10.1109/ACCESS.2017.2685629.

[2]: https://python-poetry.org/docs/dependency-specification/
