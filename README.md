# LuckDepot

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Scikit-learn](https://img.shields.io/badge/Scikit--learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white)](https://scikit-learn.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![CoreML](https://img.shields.io/badge/CoreML-0B1836?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/documentation/coreml)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://developer.apple.com/swift/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/)
[![Fork](https://img.shields.io/badge/Fork-181717?style=for-the-badge&logo=github&logoColor=white)](https://fork.com/)
[![Notion](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white)](https://notion.so/)
[![Slack](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white)](https://slack.com/)
[![Jira](https://img.shields.io/badge/Jira-0052CC?style=for-the-badge&logo=jira&logoColor=white)](https://www.atlassian.com/software/jira)
[![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)](https://figma.com/)
[![Miro](https://img.shields.io/badge/Miro-050038?style=for-the-badge&logo=miro&logoColor=white)](https://miro.com/)
[![Realm](https://img.shields.io/badge/Realm-39477F?style=for-the-badge&logo=realm&logoColor=white)](https://realm.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Hive](https://img.shields.io/badge/Hive-FFC107?style=for-the-badge&logo=hive&logoColor=white)](https://pub.dev/packages/hive)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Firebase Auth](https://img.shields.io/badge/Firebase%20Auth-FFCA28?style=for-the-badge&logo=firebase&logoColor=white)](https://firebase.google.com/)
[![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)](https://jupyter.org/)


---

## Table of Contents

- [Overview](#overview)
- [Branch Structure](#Branch_Structure)
- [Demo Video](#demo-video)
- [Features](#features)
- [My Roles & Responsibilities](#my-roles--responsibilities)
- [Project Structure (MVVM)](#project-structure-mvvm)
- [Tech Stack](#tech-stack)
- [Main Packages](#main-packages)
- [System Architecture](#system-architecture)
- [Database](#database)
- [Screen Flow Diagram](#screen-flow-diagram)
- [Screenshots](#screenshots)
- [How to Run](#how-to-run)
- [Contact](#contact)

---

## Overview

Lucky Depot is a logistics management system with both a consumer app and an admin web.  
Key features include delivery date prediction, product search using images, product registration, and driver management.

- **Team Size:** 5 members  
- **Project Duration:** January 10, 2025 – February 5, 2025
  
---

## Branch Structure

- `main`: Final merge/backup branch (no actual source code)
- `yh`: Branch where I developed almost the entire admin web using Flutter and Hive (except for the login page)
- `web`: Final branch where the admin web from `yh` was merged and deployed
- Others: fastapi, angie, etc. for backend and other features

> Except for the login page, I developed all admin web features in the `yh` branch.  
> The final deliverable is available in the `web` branch.

---

## Database Structure & Execution Notice

- The main database was **PostgreSQL** running in a Docker container on a Linux server.
- **Hive** was used only for driver registration and deletion within the admin web (Flutter).
- All other major data and features relied on PostgreSQL.

> ⚠️ **Note:**  
> The Linux server and Docker environment for PostgreSQL are no longer available.  
> As a result, it is currently **not possible to run the full project or access the main database**.  
> Please refer to the demo video for actual functionality and features.


---

## Demo Video

**Links:**  
- [Demo Video](https://youtu.be/iPYmU4KXNjw)

---

## Features

- Real-time private chat and open chat rooms
- User search and friend management (add/delete/search)
- Music appreciation and sharing
- Backend powered by FastAPI & MySQL, with Firebase for chat and storage

---

## My Roles & Responsibilities

- Delivery date prediction based on location
- Product search using product images
- Admin web for product registration and management
- Driver and operational status management
- Data visualization with Syncfusion Flutter Charts

---

## Project Structure (MVVM)

This project applies the MVVM (Model-View-ViewModel) architecture for clear separation of concerns and maintainability.

- **Model (10 files):** Defines core data structures and business logic.
- **View (19 files):** Implements UI pages and reusable widgets.
- **ViewModel (9 files):** Handles state management and connects views with models.

> All files were implemented in Dart, following Flutter best practices.

---

## Tech Stack

Frameworks:
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>

Languages:
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>

Database:
<img src="https://img.shields.io/badge/Hive-FFC107?style=for-the-badge&logo=hive&logoColor=white"/>

Collaboration:
<img src="https://img.shields.io/badge/Fork-181717?style=for-the-badge&logo=github&logoColor=white"/>

Design/Planning:
<img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white"/>
<img src="https://img.shields.io/badge/Miro-050038?style=for-the-badge&logo=miro&logoColor=white"/>

Tools:
<img src="https://img.shields.io/badge/VS%20Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white"/>
<img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>
---

## Main Packages

- `get`: Routing and state management (`^4.6.6`)
- `hive_ce`: Hive Community Edition core package (`^2.9.0`)
- `hive_ce_flutter`: Easy Hive_CE usage in Flutter (`^2.2.0`)
- `responsive_framework`: Responsive framework for Flutter web (`^1.5.1`)
- `flutter_map`: Flutter map package (`^7.0.2`)
- `latlong2`: Latitude and longitude (`^0.9.1`)
- `http`: HTTP client (`^1.2.2`)
- `file_picker`: File picker (`^8.1.7`)
- `syncfusion_flutter_charts`: Chart library (`^28.2.4+1`)
- `intl`: Internationalization (`^0.20.2`)
- `google_fonts`: Google Fonts (`^6.2.1`)
- `flutter_hooks`: Hooks for Flutter (`^0.20.5`)


---

## System Architecture

![System Configuration](image/System_Architecture.png)

---

## Database

### EER Diagram  
_Only the EER diagram is provided; actual database dump is not included._

![EER Diagram](image/EER.png)

---

## System Flow Diagram

![Screen Flow Diagram](image/SFD.png)

---

## Screenshots

### Main Screenshots (Features I Developed)

![DashBoard](image/DashBoard.png)
![Sales](image/Sales.png)
![Product_Addition_and_Modification](image/Product_Addition_and_Modification.png)
![Customer_and_Hub](image/Customer_and_Hub.png)
![Driver_Management](image/Driver_Management.png)

---

## How to Run

> ⚠️ The execution environment (Linux server and Docker-based PostgreSQL database) is no longer available, so it is not possible to run the project directly.
> Please refer to the demo video to see the main features and functionality.


---

## Contact

For questions, contact:  
**Terry Yoon**  
yonghyuk.terry.yoon@gmail.com
