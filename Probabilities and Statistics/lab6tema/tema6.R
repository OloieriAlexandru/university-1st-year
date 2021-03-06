# Tema 6 PS Oloieri Alexandru

# E1

t_test = function(n, population_mean, sample_mean, alpha, s, type)
{
  t_scor = (sample_mean - population_mean) / (s/sqrt(n));
  ok = FALSE;
  if (type == 1)
  {
    t_critic = qt(alpha, n-1);
    if (t_scor < t_critic)
      ok = TRUE;
  }
  else
    if (type == 2)
    {
      t_critic = qt(1 - alpha, n-1);
      if (t_scor > t_critic)
        ok = TRUE;
    }
  else
  {
    t_critic = -qt(alpha/2, n-1);
    if (abs(t_scor) > abs(t_critic))
      ok = TRUE;
  }
  if (ok == TRUE)
    cat("Se accepta ipoteza alternativa, se respinge ipoteza nula\n");
  if (ok == FALSE)
    cat("Se accepta ipoteza nula, se respinge ipoteza alternativa (nu exista sufieciente dovezi)\n");
}
t_test_vector = function(alpha, population_mean, type, x)
{
  sample_mean = mean(x);
  s = sd(x);
  n = length(x);
  t_test(n,population_mean,sample_mean,alpha,s,type);
}
mg = c(1.64,1.54,1.56,1.57,1.44,1.48,1.56);
t_test_vector(0.01,1.6,1,mg);

# E4

z_test_means = function(n1, sample_mean1, sd1, n2, sample_mean2, sd2, alpha, type, m0)
{
  ok = FALSE;
  z_score = ((sample_mean1 - sample_mean2) - m0) / (sqrt((sd1^2/n1)+(sd2^2/n2)));
  if (type == 1)
  {
    z_star = qnorm(alpha, 0, 1);
    if (z_score < z_star)
      ok = TRUE;
  }
  else
    if (type == 2)
    {
      z_star = qnorm(1-alpha, 0, 1);
      if (z_score > z_star)
        ok = TRUE;
    }
  else
    if (type == 3)
    {
      z_star = qnorm(1-alpha/2,0,1);
      if (abs(z_score) > abs(z_star))
        ok = TRUE;
    }
  if (ok == TRUE)
    cat("Se accepta ipoteza alternativa, se respinge ipoteza nula\n");
  if (ok == FALSE)
    cat("Se accepta ipoteza nula, se respinge ipoteza alternativa (nu exista sufieciente dovezi)\n");
  #ans = c(z_star, z_score);
  #return (ans);
}
# ipoteza alternativa: cele 2 medii sunt diferite
z_test_means(155,15,0.75,150,14.5,0.78,0.01,3,0);
z_test_means(155,15,0.75,150,14.5,0.78,0.05,3,0);

# E6
f_test = function(n1,s1,n2,s2,alpha,type)
{
  ok = FALSE;
  f_scor = (s1^2)/(s2^2);
  if (type == 1)
  {
    f_star = qf(alpha/2, n1-1,n2-1);
    if (f_scor< f_star)
      ok = TRUE;
  }
  else
    if (type == 2)
    {
      f_star = qf(1-alpha/2, n1-1,n2-1);
      if (f_scor > f_star)
        ok = TRUE;
    }
  else
  {
    f_star_left = qf(alpha/2,n1-1,n2-1);
    f_star_right = qf(1-alpha/2,n1-1,n2-1);
    if (f_scor < f_star_left | f_scor > f_star_right)
      ok = TRUE;
    #cat(f_star_left," ",f_star_right,"\n");
  }
  if (ok == TRUE)
    cat("Se accepta ipoteza alternativa, se respinge ipoteza nula\n");
  if (ok == FALSE)
    cat("Se accepta ipoteza nula, se respinge ipoteza alternativa (nu exista sufieciente dovezi)\n");
}
# ipoteza alternativa: dispersiile celor doua populatii sunt diferite
f_test(197,0.6,204,0.9,0.01,3)