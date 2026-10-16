# LM Triangulation
> **FR —** Retrouver la position d’un téléphone grâce aux distances mesurées par trois stations de base.  
> **EN —** Locate a mobile phone using distance measurements from three base stations.
## Sommaire / Contents
### Français
- [1. Résumé simple](#resume-simple)
- [2. Contexte](#contexte)
- [3. Objectifs et outils](#objectifs-et-outils)
- [4. Organisation du projet](#organisation-du-projet)
- [5. Architecture du code](#architecture-du-code)
- [6. Difficultés et solutions](#difficultes-et-solutions)
- [7. Résultats non techniques](#resultats-non-techniques)
### English
- [1. Simple summary](#simple-summary)
- [2. Context](#context)
- [3. Project goals and tools](#project-goals-and-tools)
- [4. Project organization](#project-organization)
- [5. Code architecture](#code-architecture)
- [6. Challenges and solutions](#challenges-and-solutions)
- [7. Non-technical outcomes](#non-technical-outcomes)
<a id="resume-simple"></a>
## 1. Résumé simple
Ce projet estime la position d’un téléphone à partir des distances entre celui-ci et trois stations de base. Il s’appuie sur l’optimisation numérique pour trouver le point qui correspond le mieux aux mesures.
<a id="simple-summary"></a>
## 1. Simple summary
This project estimates a mobile phone’s position from its distances to three base stations. It uses numerical optimization to find the point that best fits the measurements.
<a id="contexte"></a>
## 2. Contexte
<a id="context"></a>
## 2. Context
<a id="objectifs-et-outils"></a>
## 3. Objectifs et outils
L’objectif est de calculer la position du téléphone à partir des coordonnées des trois stations et de leurs mesures de distance bruitées. Le projet explore les méthodes des moindres carrés non linéaires et de Levenberg–Marquardt, notamment leur variante pondérée par la variance des mesures. Il vise aussi à observer l’influence du nombre de mesures et de la pondération sur la stabilité de l’estimation.
Le code est écrit en **MATLAB**. Il utilise des fonctions compilées fournies sous forme de fichiers `.p` pour obtenir les mesures bruitées, ainsi que des fonctions MATLAB pour calculer les distances, mettre à jour l’estimation et produire des graphiques.
<a id="project-goals-and-tools"></a>
## 3. Project goals and tools
The goal is to calculate the phone’s position from the coordinates of the three stations and their noisy distance measurements. The project explores nonlinear least-squares and Levenberg–Marquardt methods, including a variant weighted by measurement variance. It also aims to observe how the number of measurements and weighting affect the stability of the estimate.
The code is written in **MATLAB**. It uses supplied compiled `.p` functions to generate noisy measurements, alongside MATLAB functions to calculate distances, update the estimate, and create plots.
<a id="organisation-du-projet"></a>
## 4. Organisation du projet
<a id="project-organization"></a>
## 4. Project organization
<a id="architecture-du-code"></a>
## 5. Architecture du code
- **`assignment1.m`** — principal script: defines station coordinates, generates measurements, estimates the position with weighted Levenberg–Marquardt, and plots the results.
- **`circles.m`** — helper functions for generating and plotting circles around the stations.
- **`main_file.asv`** — MATLAB autosave containing an earlier version of the script.
- **`ping_stolp_1.p`, `ping_stolp_2.p`, `ping_stolp_3.p`** — compiled measurement functions, one per station.
- **`medias/`** — plots illustrating estimated trajectories, errors, cost, and gradients for different runs or methods.
- **`VAJA1_ang.docx` and `Report.pdf`** — assignment description and project report.
<a id="code-architecture"></a>
## 5. Code architecture
- **`assignment1.m`** — main script: defines station coordinates, generates measurements, estimates the position using weighted Levenberg–Marquardt, and plots the results.
- **`circles.m`** — helper functions for generating and plotting circles around the stations.
- **`main_file.asv`** — MATLAB autosave containing an earlier version of the script.
- **`ping_stolp_1.p`, `ping_stolp_2.p`, `ping_stolp_3.p`** — compiled measurement functions, one per station.
- **`medias/`** — plots showing estimated trajectories, errors, cost, and gradients for different runs or methods.
- **`VAJA1_ang.docx` and `Report.pdf`** — assignment brief and project report.
<a id="difficultes-et-solutions"></a>
## 6. Difficultés et solutions
### Difficultés techniques
- **Mesures bruitées et de variances différentes :** le projet estime une variance par station et l’utilise pour pondérer les mesures dans la mise à jour WLM.
- **Estimation non linéaire :** les distances dépendent de la position recherchée. Le script calcule leur jacobienne et applique une mise à jour de Levenberg–Marquardt.
- **Association des mesures aux stations :** dans la boucle principale, les trois résidus doivent être calculés à partir des trois mesures correspondant à une même itération. La version déposée utilise `radii(iter)` au lieu du vecteur `radii(:, iter)` ; cette indexation doit être corrigée et les résultats recalculés avant de tirer des conclusions fiables.
### Difficultés organisationnelles
Le dépôt contient le script courant, une sauvegarde MATLAB, des fonctions compilées et des figures, mais ne documente pas de procédure d’exécution ni de protocole de comparaison. Un point de départ pour améliorer la reproductibilité est de documenter la version MATLAB requise, l’ordre d’exécution et les paramètres utilisés dans chaque expérience.
<a id="challenges-and-solutions"></a>
## 6. Challenges and solutions
### Technical challenges
- **Noisy measurements with different variances:** the project estimates a variance for each station and uses it to weight measurements in the WLM update.
- **Nonlinear estimation:** distances depend on the unknown position. The script calculates their Jacobian and applies a Levenberg–Marquardt update.
- **Matching measurements to stations:** in the main loop, all three residuals must be calculated from the three measurements belonging to the same iteration. The checked-in version uses `radii(iter)` instead of the vector `radii(:, iter)`; this indexing needs to be corrected and the results recomputed before drawing reliable conclusions.
### Organizational challenges
The repository contains the current script, a MATLAB autosave, compiled functions, and figures, but does not document an execution procedure or comparison protocol. Documenting the required MATLAB version, run order, and parameters used for each experiment would provide a starting point for improving reproducibility.
<a id="resultats-non-techniques"></a>
## 7. Résultats non techniques
Le projet cherche à transformer plusieurs mesures de distance en une estimation facile à interpréter : un point représentant la position probable du téléphone. Les figures fournies rendent l’évolution de cette estimation et des erreurs plus visibles. Une comparaison fiable entre les méthodes et le nombre de mesures reste à confirmer après correction de l’indexation des résidus.
<a id="non-technical-outcomes"></a>
## 7. Non-technical outcomes
The project aims to turn several distance measurements into an easy-to-understand estimate: a point representing the phone’s likely position. The supplied plots make the estimate’s progress and errors easier to inspect. A reliable comparison across methods and measurement counts still needs to be confirmed after correcting the residual indexing.