Select * FROM Covid_Portfolio_Project.coviddeath

#Total cases vs Population#
Select Location, Population, total_cases
from Covid_Portfolio_Project.coviddeath


#Total cases in Nigeria#
Select Location, Date, Population, total_cases, total_deaths
from covid_portfolio_project.coviddeath
where Location like '%Nigeria%'


#Death rate In Nigeria, showin what % of the population died from covid#
Select Location, Date, Population, total_cases, (total_deaths/total_cases)*100 as DeathPercentage
from covid_portfolio_project.coviddeath
where Location like '%Nigeria%'

#Countries with the highest infection rate vs Population
Select Location, Population, Max(total_cases) as HighestCaseCount, Max((total_cases/population))*100 as MaxDeathRate
from Covid_Portfolio_Project.coviddeath
Group by Location, Population
order by 4 desc

#Countries with the Highest Death Count per Population
Select Location, max(cast(total_deaths as int)) as Highestdeathcount
from covid_portfolio_project.coviddeath
where continent is not null
Group by Location 
Order by 2 desc 

#continents with the highest death count#
Select continent, max(total_deaths) as Highestdeathcount
from covid_portfolio_project.coviddeath
Group by continent 
Order by 2 desc 

#World numbers 
Select Date, sum(new_cases) as 'total world number', sum(new_deaths) as 'Sum Total cases', sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from covid_portfolio_project.coviddeath
group by 1
order by 3 Asc

#Joining both tables I.e coviddeath and vaccination#
select *
From covid_portfolio_project.coviddeath cd
Join Covid_portfolio_project.covidvaccinations cv
	On cd.location = cv.location
    and cd.date = cv.date
    

#Total population vaccinated 
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, sum(new_vaccinations) over (partition by cd.Location order by cd.location, cd.date) as IncreasingVaccination
From covid_portfolio_project.coviddeath cd
Join Covid_portfolio_project.covidvaccinations cv
	On cd.location = cv.location
    and cd.date = cv.date
order by 1, 2, 3

#population vs vaccinated 
with PopvsVac (continent, location, date, Population, New_vaccinations, IncreasingVaccination)
as
(select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, sum(new_vaccinations) over (partition by cd.Location order by cd.location, cd.date) as IncreasingVaccination
From covid_portfolio_project.coviddeath cd
Join Covid_portfolio_project.covidvaccinations cv
	On cd.location = cv.location
    and cd.date = cv.date
)
select *, (Increasingvaccination/Population)*100 as VaccinationPercentageIncrease
from PopvsVac

#visualization setups
use covid_portfolio_project
drop table if exists  covid_portfolio_project.PercentPopulationVaccinated
Create table covid_portfolio_project.PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
IncreasingVaccination Numeric
)
Insert into covid_portfolio_project.PercentPopulationVaccinated
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, sum(new_vaccinations) over (partition by cd.Location order by cd.location, cd.date) as IncreasingVaccinationercentPopulationVaccinated
From covid_portfolio_project.coviddeath cd
Join Covid_portfolio_project.covidvaccinations cv
	On cd.location = cv.location
    and cd.date = cv.date)
    
    
#Creating View PopulationVaccinated_View
CREATE VIEW PopulationVaccinatedPercent AS
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, sum(new_vaccinations) over (partition by cd.Location order by cd.location, cd.date) as IncreasingVaccination
From covid_portfolio_project.coviddeath cd
Join Covid_portfolio_project.covidvaccinations cv
	On cd.location = cv.location
    and cd.date = cv.date
order by 1, 2, 3


