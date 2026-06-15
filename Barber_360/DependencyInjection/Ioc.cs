using Application.Interfaces;
using Application.Interfaces.Login;
using Application.Interfaces.PersonDelete;
using Application.Interfaces.PersonUpdate;
using Application.Interfaces.RegisterUser;
using Application.Interfaces.Token;
using Application.Servicios;
using Application.Servicios.Login;
using Application.Servicios.PersonDelete;
using Application.Servicios.PersonUpdate;
using Application.Servicios.RegisterUser;
using Application.Servicios.Token;
using Domain.Interfaces.GetUserByEmail;
using Domain.Interfaces.PersonDelete;
using Domain.Interfaces.PersonUpdate;
using Domain.Interfaces.RegisterUser;
using Infrastructure.Persistence;
using Infrastructure.Repositories.GetUserByEmail;
using Infrastructure.Repositories.Person;
using Infrastructure.Repositories.PersonUpdate;
using Infrastructure.Repositories.RegisterUser;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace DependencyInjection
{
    public static class Ioc
    {
        public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddSingleton<DapperContext>();

            services.AddScoped<IRegisterUserBLL,RegisterUserBLL>();
            services.AddScoped<ILoginBLL, LoginBLL>();
            services.AddScoped<ITokenBLL, TokenBLL>();
            services.AddScoped<IPersonUpdateBLL,PersonUpdateBLL>();
            services.AddScoped<IPersonDeleteBLL,PersonDeleteBLL>();

            services.AddScoped<IGetUserByEmailDAL, GetUserByEmailDAL>();
            services.AddScoped<IGetUserByEmailDAL, GetUserByEmailDAL>();
            services.AddScoped<IPersonUpdateDAL, PersonUpdateDAL>();
            services.AddScoped<IPersonDeleteDAL, PersonDeleteDAL>();
            services.AddScoped<IRegisterUserDAL, RegisterUserDAL>();

            return services;
        }
    }
}
