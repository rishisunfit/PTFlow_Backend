-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.12 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA public;


SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE public.clients (
    id uuid NOT NULL,
    dob date
);


CREATE TABLE public.coach_clients (
    coach_id uuid NOT NULL,
    client_id uuid NOT NULL
);


CREATE TABLE public.coaches (
    id uuid NOT NULL,
    bio text
);


CREATE TABLE public.group_members (
    group_id uuid NOT NULL,
    client_id uuid NOT NULL,
    joined_at timestamp without time zone DEFAULT now()
);


CREATE TABLE public.groups (
    id uuid NOT NULL,
    coach_id uuid,
    name text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now()
);


CREATE TABLE public.ptf_exercise_library (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    video_url_1 text,
    video_url_2 text,
    default_unit text,
    muscles_trained text[],
    exercise_type text,
    target_goal text,
    difficulty text,
    equipment text[],
    instructions text,
    regression_ids uuid[],
    progression_ids uuid[],
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


CREATE TABLE public.ptf_program_template_workouts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    program_template_id uuid,
    workout_id uuid,
    day integer NOT NULL,
    "order" integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


CREATE TABLE public.ptf_program_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


CREATE TABLE public.ptf_workout_exercises (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workout_id uuid,
    exercise_id uuid,
    sets integer,
    reps integer,
    rest_seconds integer,
    "order" integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    "Workout_Specific_Instructions" text
);


CREATE TABLE public.ptf_workouts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


CREATE TABLE public.team_members (
    id uuid NOT NULL,
    team_id uuid,
    user_id uuid,
    sub_role text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT team_members_sub_role_check CHECK ((sub_role = ANY (ARRAY['head_coach'::text, 'assistant'::text, 'admin'::text, 'nutritionist'::text])))
);


CREATE TABLE public.teams (
    id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


CREATE TABLE public.users (
    id uuid NOT NULL,
    email text NOT NULL,
    full_name text,
    avatar_url text,
    role text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT users_role_check CHECK ((role = ANY (ARRAY['coach'::text, 'client'::text])))
);


ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.coach_clients
    ADD CONSTRAINT coach_clients_pkey PRIMARY KEY (coach_id, client_id);


ALTER TABLE ONLY public.coaches
    ADD CONSTRAINT coaches_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (group_id, client_id);


ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.ptf_exercise_library
    ADD CONSTRAINT ptf_exercise_library_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.ptf_program_template_workouts
    ADD CONSTRAINT ptf_program_template_workouts_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.ptf_program_templates
    ADD CONSTRAINT ptf_program_templates_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.ptf_workout_exercises
    ADD CONSTRAINT ptf_workout_exercises_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.ptf_workouts
    ADD CONSTRAINT ptf_workouts_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_id_fkey FOREIGN KEY (id) REFERENCES public.users(id);


ALTER TABLE ONLY public.coach_clients
    ADD CONSTRAINT coach_clients_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


ALTER TABLE ONLY public.coach_clients
    ADD CONSTRAINT coach_clients_coach_id_fkey FOREIGN KEY (coach_id) REFERENCES public.coaches(id);


ALTER TABLE ONLY public.coaches
    ADD CONSTRAINT coaches_id_fkey FOREIGN KEY (id) REFERENCES public.users(id);


ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_coach_id_fkey FOREIGN KEY (coach_id) REFERENCES public.coaches(id);


ALTER TABLE ONLY public.ptf_program_template_workouts
    ADD CONSTRAINT ptf_program_template_workouts_program_template_id_fkey FOREIGN KEY (program_template_id) REFERENCES public.ptf_program_templates(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.ptf_program_template_workouts
    ADD CONSTRAINT ptf_program_template_workouts_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.ptf_workouts(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.ptf_workout_exercises
    ADD CONSTRAINT ptf_workout_exercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.ptf_exercise_library(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.ptf_workout_exercises
    ADD CONSTRAINT ptf_workout_exercises_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.ptf_workouts(id) ON DELETE CASCADE;


ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id);


