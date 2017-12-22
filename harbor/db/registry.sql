drop database if exists registry;
create database registry charset = utf8;

use registry;

create table access (
 access_id int NOT NULL AUTO_INCREMENT,
 access_code char(1),
 comment varchar (30),
 primary key (access_id)
);

insert into access (access_code, comment) values 
('M', 'Management access for project'),
('R', 'Read access for project'),
('W', 'Write access for project'),
('D', 'Delete access for project'),
('S', 'Search access for project');


create table role (
 role_id int NOT NULL AUTO_INCREMENT,
 role_mask int DEFAULT 0 NOT NULL,
 role_code varchar(20),
 name varchar (20),
 primary key (role_id)
);
/*
role mask is used for future enhancement when a project member can have multi-roles
currently set to 0
*/

insert into role (role_code, name) values 
('MDRWS', 'projectAdmin'),
('RWS', 'developer'),
('RS', 'guest');


create table user (
 user_id int NOT NULL AUTO_INCREMENT,
# The max length of username controlled by API is 20, 
# and 11 is reserved for marking the deleted users.
# The mark of deleted user is "#user_id".
# The 11 consist of 10 for the max value of user_id(4294967295)  
# in MySQL and 1 of '#'.
 username varchar(32),
# 11 bytes is reserved for marking the deleted users.
 email varchar(255),
 password varchar(40) NOT NULL,
 realname varchar (20) NOT NULL,
 comment varchar (30),
 deleted tinyint (1) DEFAULT 0 NOT NULL,
 reset_uuid varchar(40) DEFAULT NULL,
 salt varchar(40) DEFAULT NULL,
 sysadmin_flag tinyint (1),
 creation_time timestamp,
 update_time timestamp,
 primary key (user_id),
 UNIQUE (username),
 UNIQUE (email)
);

insert into user (username, email, password, realname, comment, deleted, sysadmin_flag, creation_time, update_time) values 
('admin', 'admin@example.com', '', 'system admin', 'admin user',0, 1, NOW(), NOW()),
('anonymous', 'anonymous@example.com', '', 'anonymous user', 'anonymous user', 1, 0, NOW(), NOW()),
('clairuser', 'clair@example.com', '', 'clair user', 'clair user',0, 0, NOW(), NOW());
                                                                          
create table project (
 project_id int NOT NULL AUTO_INCREMENT,
 owner_id int NOT NULL,
 # The max length of name controlled by API is 30, 
 # and 11 is reserved for marking the deleted project.
 name varchar (41) NOT NULL,
 creation_time timestamp,
 update_time timestamp,
 deleted tinyint (1) DEFAULT 0 NOT NULL,
 public tinyint (1) DEFAULT 0 NOT NULL,
 primary key (project_id),
 FOREIGN KEY (owner_id) REFERENCES user(user_id),
 UNIQUE (name)
);

insert into project (owner_id, name, creation_time, update_time, public) values 
(1, 'library', NOW(), NOW(), 1),(2, 'k8s-deploy', NOW(), NOW(), 1);

create table project_member (
 project_id int NOT NULL,
 user_id int NOT NULL,
 role int NOT NULL,
 creation_time timestamp,
 update_time timestamp,
 PRIMARY KEY (project_id, user_id),
 FOREIGN KEY (role) REFERENCES role(role_id),
 FOREIGN KEY (project_id) REFERENCES project(project_id),
 FOREIGN KEY (user_id) REFERENCES user(user_id)
 );

insert into project_member (project_id, user_id, role, creation_time, update_time) values
(1, 1, 1, NOW(), NOW());

create table access_log (
 log_id int NOT NULL AUTO_INCREMENT,
 user_id int NOT NULL,
 project_id int NOT NULL,
 repo_name varchar (256), 
 repo_tag varchar (128),
 GUID varchar(64), 
 operation varchar(20) NOT NULL,
 op_time timestamp,
 primary key (log_id),
 INDEX pid_optime (project_id, op_time),
 FOREIGN KEY (user_id) REFERENCES user(user_id),
 FOREIGN KEY (project_id) REFERENCES project (project_id)
);

create table repository (
 repository_id int NOT NULL AUTO_INCREMENT,
 name varchar(255) NOT NULL,
 project_id int NOT NULL,
 owner_id int NOT NULL,
 description text,
 pull_count int DEFAULT 0 NOT NULL,
 star_count int DEFAULT 0 NOT NULL,
 creation_time timestamp default CURRENT_TIMESTAMP,
 update_time timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
 primary key (repository_id),
 UNIQUE (name)
);

#other_status 1:clair not support 2:clair success 3:abnormal 4:mild CVE 5:high CVE
#NEW TABLE CREATE BY YL
#the unit of images size is MB
create table clair_result (
 clair_id int NOT NULL AUTO_INCREMENT,
 repo_name varchar(255) NOT NULL,
 user_name varchar(255) NOT NULL,
 project_name varchar(255) NOT NULL,
 high_num int NOT NULL,
 other_num int NOT NULL,
 clair_result LONGTEXT,
 other_status int NOT NULL,
 CVE_status int NOT NULL,
 image_size numeric(20,5) NOT NULL,
 primary key (clair_id),
 UNIQUE (repo_name)
);

#NEW TABLE CREATE BY YL
create table bench_security (
 id int NOT NULL AUTO_INCREMENT,
 ip varchar(255) NOT NULL,
 host_configuration text,
 docker_daemon_configuration text,
 docker_daemon_configuration_files text,
 container_images_and_build_files text,
 docker_security_operations text,
 primary key (id),
 UNIQUE (ip)
);
#lili
#the unit of images size is MB
create table project_quota(
 quota_id int NOT NULL AUTO_INCREMENT,
 project_id int NOT NULL,
 project_name varchar (41) NOT NULL,
 quota_size numeric(20,5) NOT NULL,
 use_size numeric(20,5)NOT NULL,
 quota_num int NOT NULL,
 use_num int NOT NULL,
 deleted tinyint (1) DEFAULT 0 NOT NULL,
 primary key (quota_id),
 FOREIGN KEY (project_id) REFERENCES project (project_id),
 UNIQUE (project_name)
);
insert into project_quota (quota_id,project_id, project_name,quota_size,use_size,quota_num,use_num) values 
(1,1, 'library',10000.0, 0.0, 50, 0),(2,2, 'k8s-deploy',10000.0, 0.0, 50, 0);

#NEW TABLE create by YL
create table bench_security_runTime (
 id int NOT NULL AUTO_INCREMENT,
 continer_id varchar(255) NOT NULL,
 continer_name varchar(255) NOT NULL,
 ip varchar(255) NOT NULL,
 container_runtime text,
 primary key (id),
 UNIQUE (continer_id)
);

create table replication_policy (
 id int NOT NULL AUTO_INCREMENT,
 name varchar(256),
 project_id int NOT NULL,
 target_id int NOT NULL,
 enabled tinyint(1) NOT NULL DEFAULT 1,
 description text,
 deleted tinyint (1) DEFAULT 0 NOT NULL,
 cron_str varchar(256),
 start_time timestamp NULL,
 creation_time timestamp default CURRENT_TIMESTAMP,
 update_time timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
 PRIMARY KEY (id)
 );

create table replication_target (
 id int NOT NULL AUTO_INCREMENT,
 name varchar(64),
 url varchar(64),
 username varchar(40),
 password varchar(128),
 /*
 target_type indicates the type of target registry,
 0 means it's a harbor instance,
 1 means it's a regulart registry
 */
 target_type tinyint(1) NOT NULL DEFAULT 0,
 creation_time timestamp default CURRENT_TIMESTAMP,
 update_time timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
 PRIMARY KEY (id)
 );

create table replication_job (
 id int NOT NULL AUTO_INCREMENT,
 status varchar(64) NOT NULL,
 policy_id int NOT NULL,
 repository varchar(256) NOT NULL,
 operation  varchar(64) NOT NULL,
 tags   varchar(16384),
 creation_time timestamp default CURRENT_TIMESTAMP,
 update_time timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
 PRIMARY KEY (id),
 INDEX policy (policy_id),
 INDEX poid_uptime (policy_id, update_time)
 );
 
create table properties (
 k varchar(64) NOT NULL,
 v varchar(128) NOT NULL,
 primary key (k)
 );

insert into properties (k, v) values ("admin_detectTime", "30");
insert into properties (k, v) values ("admin_cycleTime", "15"); 

CREATE TABLE IF NOT EXISTS `alembic_version` (
    `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into alembic_version values ('0.4.0');
