### Analyzing the entire dataset ###
SELECT * FROM bank_schema.bank_targets;

# Total number of rows
select count(age) from bank_schema.bank_targets; 

# Age distribution statistics
select min(age) as min_age, max(age) as max_age, avg(age) as mean_age, max(age) - min(age) as range_age from bank_schema.bank_targets; 

# Occupation distribution statistics
select job, count(job) as number_of_people_wtih_this_job from bank_schema.bank_targets group by job order by count(job) DESC; 
# Retrieve the number of unique occupations
select count(distinct job) from bank_schema.bank_targets; 
# Calculate percentages of each occupation
select (969/count(*))*100, (946/count(*))*100, (768/count(*))*100, (478/count(*))*100,(417/count(*))*100, (230/count(*))*100, (183/count(*))*100,(168/count(*))*100, (128/count(*))*100, (112/count(*))*100, (84/count(*))*100, (38/count(*))*100 from bank_schema.bank_targets; 

# Marital status statistics
select marital, count(marital) as number_of_people from bank_schema.bank_targets group by marital; 
# Calculate percentages of customers in each marital status
select (2797/count(*))*100, (1196/count(*))*100, (528/count(*))*100 from bank_schema.bank_targets; 

# Education statistics
update bank_schema.bank_targets set education = "secondary" where education = "unknown";
select education, count(education) as number_of_people from bank_schema.bank_targets group by education;
# Calculate percentages of customers in each education level
select (678/count(*))*100, (2493/count(*))*100 , (1350/count(*))*100 from bank_schema.bank_targets;

# Default rate statistics
select default_rate, count(default_rate) as number_of_people from bank_schema.bank_targets group by default_rate;
# Calculate percentages of customers for each default rate
select (4445/count(*))*100 as `No_%`, (76/count(*))*100 as `Yes_%` from bank_schema.bank_targets;

# Balance statistics
select min(balance) as min, max(balance) as max, avg(balance) as mean, (max(balance)-min(balance)) as `range` from bank_schema.bank_targets;

# Housing statistics
select housing, count(housing) as num_people from bank_schema.bank_targets group by housing;
# Calculate percentages of customers for each housing category
select (1962/count(*))*100 as `No_%`, (2559/count(*))*100 as `Yes_%` from bank_schema.bank_targets;

# Loan statistics
select loan, count(loan) as num_loan from bank_schema.bank_targets group by loan;
# Calculate percentages of customers for each loan category
select (3830/count(*))*100 as `No_%`, ((691/count(*))*100) as `Yes_%` from bank_schema.bank_targets;

# Last contact month analysis
select `month`, count(`month`) from bank_schema.bank_targets group by `month` order by count(`month`);
# Calculate percentages of customers for each month
select (20/count(*))*100 as december, (49/count(*))*100 as march, (52/count(*))*100 as september, (80/count(*))*100 as october, (148/count(*))*100 as january, (222/count(*))*100 as february, (293/count(*))*100 as april, (389/count(*))*100 as november, (531/count(*))*100 as june, (633/count(*))*100 as august, (706/count(*))*100 as july, (1398/count(*))*100 as may from bank_schema.bank_targets;

# Duration of phone call analysis
select min(duration) as min_duration, max(duration) as max_duration, avg(duration) as average_duration, max(duration) - min(duration) as range_duration from bank_schema.bank_targets;

# Number of contacts performed for each client
select min(campaign) as min_contacts, max(campaign) as max_contacts, avg(campaign) as average_contacts from bank_schema.bank_targets;

# Number of days that passed by after the client was last contacted from a previous campaign
# alter table bank_schema.bank_targets rename column pdays to days_passed;
select count(days_passed) from bank_schema.bank_targets where days_passed = -1;
select avg(days_passed) from bank_schema.bank_targets where days_passed != -1;

# Number of contacts performed before this campaign for each customer 
#alter table bank_schema.bank_targets rename column previous to previous_contacts;
select avg(previous_contacts) from bank_schema.bank_targets;
select previous_contacts, count(previous_contacts) from bank_schema.bank_targets group by previous_contacts order by count(previous_contacts) desc;

# Outcome of the previous campaign
#alter table bank_schema.bank_targets rename column poutcome to previous_campaign_outcome;
select previous_campaign_outcome, count(previous_campaign_outcome) as count from bank_schema.bank_targets group by previous_campaign_outcome order by count(previous_campaign_outcome);
# Calculate percentages
select (129/count(*))*100 as success, (490/count(*))*100 as failure, (197/count(*))*100 as other, (3705/count(*))*100 as `unknown` from bank_schema.bank_targets;

# Customers' responses to term deposit
select y, count(y) as number_of_customers from bank_schema.bank_targets group by y;

# Housing ownership
select housing, count(housing) from bank_schema.bank_targets where y = "yes" group by housing;
select (301/521)*100 as `no`, (220/521)*100 as `yes`;
select (93/521)*100 as may, (61/521)*100 as july, (79/521)*100 as aug, (55/521)*100 as june, (39/521)*100 as november, (56/521)*100 as april, (38/521)*100 as february, (16/521)*100 as january, (37/521)*100 as october, (17/521)*100 as september, (21/521)*100 as march, (9/521)*100 as december;

### Analyzing customers who responded "Yes" to term deposit ###
#Age distribution
select min(age),max(age), avg(age), max(age) - min(age) as `range` from bank_schema.bank_targets where y = "yes";

# Occupation
select count(distinct job) from bank_schema.bank_targets where y = "yes";
select job, count(job) from bank_schema.bank_targets where y = "yes" group by job order by count(job) desc;
select (131/521)*100 AS management, (83/521)*100 as blue_collar, (69/521)*100 as technician, (58/521)*100 as administration, (54/521)*100 as services, (38/521)*100 as retired, (20/521)*100 as sel_employed, (19/521)*100 as entrepreneur, (15/521)*100 as unemployed, (14/521)*100 as housemaid, (13/521)*100 as students, (7/521)*100 as `unknown`;

# Marital status
select marital, count(marital) from bank_schema.bank_targets where y = "yes" group by marital;
select (277/521)*100 as married, (167/521)*100 as single, (77/521)*100 as divorced;

# Education
select education, count(education) from bank_schema.bank_targets where y="yes" group by education;
select (264/521)*100 as `secondary`, (193/521)*100 as tertiary, (64/521)*100 as `primary`;

# Default rate
select default_rate, count(default_rate) from bank_schema.bank_targets where y = "yes" group by default_rate;
select (512/521)*100 as `no`, (9/521)*100 as `yes`;

# Balance
select min(balance), max(balance), avg(balance), max(balance)-min(balance) as `range` from bank_schema.bank_targets where y = "yes";

# Loan
select loan, count(loan) from bank_schema.bank_targets where y = "yes" group by loan;
select (478/521)*100 as `no`, (43/521)*100 as `yes`;

# Month of previous contact
select `month`, count(`month`) from bank_schema.bank_targets where y = "yes" group by `month` order by count(month) desc;

# Duration of phone call
select min(duration), max(duration), avg(duration), max(duration) - min(duration) as `range` from bank_schema.bank_targets where y = "yes";

# Number of contacts in this campaign
select min(campaign), max(campaign), avg(campaign) from bank_schema.bank_targets where y = "yes";

# Number of days passed by after last contact
select count(days_passed) from bank_schema.bank_targets where y = "yes" and days_passed = -1;
select avg(days_passed) from bank_schema.bank_targets where y = "yes" and days_passed != -1;

# Number of contacts performed before this campaign
select count(previous_contacts) from bank_schema.bank_targets where y = "yes" and previous_contacts = 0;
select avg(previous_contacts) from bank_schema.bank_targets where y = "yes" and previous_contacts != 0;

# Outcome of the previous campaign
select previous_campaign_outcome, count(previous_campaign_outcome) from bank_schema.bank_targets where y = "yes" group by previous_campaign_outcome order by previous_campaign_outcome;
select (83/521)*100 as success, (63/521)*100 as failure, (38/521)*100 as other, (337/521)*100 as `unknown`;

### Analyzing customers who responded "No" to term deposit ###
#Age distribution
select min(age),max(age), avg(age), max(age) - min(age) as `range` from bank_schema.bank_targets where y = "no";

# Occupation
select count(distinct job) from bank_schema.bank_targets where y = "no";
select job, count(job) from bank_schema.bank_targets where y = "no" group by job order by count(job) desc;
select (838/4000)*100 AS management, (877/4000)*100 as blue_collar, (685/4000)*100 as technician, (420/4000)*100 as administration, (379/4000)*100 as services, (176/4000)*100 as retired, (163/4000)*100 as sel_employed, (153/4000)*100 as entrepreneur, (115/4000)*100 as unemployed, (98/4000)*100 as housemaid, (65/4000)*100 as students, (31/4000)*100 as `unknown`;

# Marital status
select marital, count(marital) from bank_schema.bank_targets where y = "no" group by marital;
select (2520/4000)*100 as married, (1029/4000)*100 as single, (451/4000)*100 as divorced;

# Education
select education, count(education) from bank_schema.bank_targets where y="no" group by education;
select (614/4000)*100 as `primary`, (2229/4000)*100 as `secondary`, (1157/4000)*100 as tertiary;

# Default rate
select default_rate, count(default_rate) from bank_schema.bank_targets where y = "no" group by default_rate;
select (3933/4000)*100 as `no`, (67/4000)*100 as `yes`;

# Balance
select min(balance), max(balance), avg(balance), max(balance)-min(balance) as `range` from bank_schema.bank_targets where y = "no";

# House ownership
select housing, count(housing) from bank_schema.bank_targets where y = "no" group by housing;
select (1661/4000)*100 as `no`, (2339/4000)*100 as `yes`;

# Loan
select loan, count(loan) from bank_schema.bank_targets where y = "no" group by loan;
select (3352/4000)*100 as `no`, (648/4000)*100 as `yes`;

# Month of previous contact
select `month`, count(`month`) from bank_schema.bank_targets where y = "no" group by `month` order by count(month) desc;
select (1305/40000)*100 as may, (645/4000)*100 as july, (554/4000)*100 as aug, (476/4000)*100 as june, (350/4000)*100 as november, (237/4000)*100 as april, (184/4000)*100 as february, (132/4000)*100 as january, (43/4000)*100 as october, (35/4000)*100 as september, (28/4000)*100 as march, (11/4000)*100 as december;

# Duration of phone call
select min(duration), max(duration), avg(duration), max(duration) - min(duration) as `range` from bank_schema.bank_targets where y = "no";

# Number of contacts in this campaign
select min(campaign), max(campaign), avg(campaign) from bank_schema.bank_targets where y = "no";

# Number of days passed by after last contact
select count(days_passed) from bank_schema.bank_targets where y = "no" and days_passed = -1;
select avg(days_passed) from bank_schema.bank_targets where y = "no" and days_passed != -1;

# Number of contacts performed before this campaign
select count(previous_contacts) from bank_schema.bank_targets where y = "no" and previous_contacts = 0;
select avg(previous_contacts) from bank_schema.bank_targets where y = "no" and previous_contacts != 0;

# Outcome of the previous campaign
select previous_campaign_outcome, count(previous_campaign_outcome) from bank_schema.bank_targets where y = "no" group by previous_campaign_outcome order by previous_campaign_outcome;
select (46/4000)*100 as success, (427/4000)*100 as failure, (159/4000)*100 as other, (3368/4000)*100 as `unknown`;

