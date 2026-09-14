# Upgrade Plan: 2003-store (20260914161447)

- **Generated**: 2026-09-14 16:15:00
- **HEAD Branch**: main
- **HEAD Commit ID**: N/A

## Available Tools

**JDKs**
- JDK 17.0.20.1: C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot\bin (current project JDK, used by baseline)
- JDK 26: C:\Program Files\Java\jdk-26\bin (target LTS runtime; required by upgrade step)

**Build Tools**
- Maven 3.9.16: E:\apache-maven-3.9.16\bin (compatible with Java 26)

## Guidelines

- Upgrade the Java runtime to the latest LTS release available in the environment (Java 26).
- Keep the change minimal and focused on build/runtime compatibility.
- Run the project’s Maven test suite before and after the upgrade to validate behavior.

> Note: You can add any specific guidelines or constraints for the upgrade process here if needed, bullet points are preferred.

## Options

- Working branch: appmod/java-upgrade-20260914161447
- Run tests before and after the upgrade: true

## Upgrade Goals

- Java 26

## Technology Stack

| Technology/Dependency | Current | Min Compatible Version | Why Incompatible |
| ---------------------- | ------- | ---------------------- | --------------- |
| Java | 17 | 26 | User requested latest LTS runtime |
| Maven Compiler Plugin | 3.11.0 | 3.11.0 | Compatible with Java 26 |
| Jakarta Servlet API | 5.0.0 | 5.0.0 | Runtime remains compatible on Java 26 |
| JUnit Jupiter | 5.10.2 | 5.10.2 | Current version is compatible with Java 26 |

## Derived Upgrades

- No framework migration is required; this is a Java runtime-level build configuration upgrade.
- The project already uses Maven 3.9.16, which is compatible with Java 26 and does not require a wrapper or toolchain upgrade.
- The compiler source/target settings must be updated from 17 to 26 to align the project with the target runtime.

## Impact Analysis

### Subsection: Dependency Changes

| File | Dependency | Current | Action | Target | Reason |
|------|-----------|---------|--------|--------|--------|
| pom.xml | maven.compiler.source | 17 | upgrade | 26 | User requested Java 26 |
| pom.xml | maven.compiler.target | 17 | upgrade | 26 | User requested Java 26 |
| pom.xml | maven-compiler-plugin configuration source/target | 17 | upgrade | 26 | Align compiler with target runtime |

### Subsection: Source Code Changes

| File | Location | Current | Required Change | Reason |
|------|----------|---------|----------------|--------|
| none | - | - | No source changes expected | Current project is a straightforward Java web app without Java 17-specific compatibility breaks |

### Subsection: Configuration Changes

| File | Property/Setting | Current | Required Change | Reason |
|------|------------------|---------|-----------------|--------|
| pom.xml | compiler source/target properties | 17 | set to 26 | Target Java runtime upgrade |

### Subsection: CI/CD Changes

| File | Location | Current | Required Change |
|------|----------|---------|----------------|
| none | - | - | No CI/CD files identified that hardcode Java 17 |

### Subsection: Risks & Warnings

- **Runtime compatibility risk**: The project relies on the Java standard library and Servlet/JUnit dependencies. Java 26 is a new LTS runtime and may surface compatibility issues not visible in compile-only validation. **Mitigation**: run the full Maven test suite after the compiler upgrade and fix any breakage. 
- **Build tool compatibility**: Although Maven is already at a compatible version, older plugin versions can still behave unexpectedly on newer JDKs. **Mitigation**: keep the Maven compiler plugin at 3.11.0 and validate compile/test behavior with JDK 26.

## Upgrade Steps

- Step 1: Setup Environment
  - **Rationale**: Confirm the required JDK and build tool are available before altering the build configuration.
  - **Changes to Make**: Validate the Java 26 JDK and Maven installation paths; no project files changed.
  - **Verification**: `#appmod-list-jdks` and `#appmod-list-mavens` with expected result: JDK 26 and Maven 3.9.16 available.

- Step 2: Setup Baseline
  - **Rationale**: Establish a known-good baseline on the current Java 17 configuration before the runtime upgrade.
  - **Changes to Make**: Run the existing project build and tests under Java 17; capture current pass/fail status.
  - **Verification**: `mvn clean compile test-compile -q && mvn clean test -q` with JDK 17; expected result: current baseline passes or any failures are recorded before the upgrade.

- Step 3: Upgrade Java compiler target to 26
  - **Rationale**: Align the Maven compiler configuration with the target LTS runtime and keep the project build compatible with Java 26.
  - **Changes to Make**: Apply the Dependency Changes and Configuration Changes in pom.xml to set Java 26 as the compiler target.
  - **Verification**: `mvn clean test-compile -q` using JDK 26; expected result: project and test sources compile successfully.

- Step 4: Final Validation
  - **Rationale**: Verify the upgraded project meets the full success criteria under Java 26.
  - **Changes to Make**: Resolve any test failures or compatibility issues surfaced by the Java 26 run.
  - **Verification**: `mvn clean test -q` using JDK 26; expected result: 100% of tests pass.
