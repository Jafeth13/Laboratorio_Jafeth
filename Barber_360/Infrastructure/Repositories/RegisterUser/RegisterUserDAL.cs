using Dapper;
using Domain.Entidades.ResponseCreate;
using Domain.Entidades.User;
using Domain.Interfaces.RegisterUser;
using Infrastructure.Persistence;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Repositories.RegisterUser
{
    public class RegisterUserDAL : IRegisterUserDAL
    {

        private readonly DapperContext _context;

        public RegisterUserDAL(DapperContext context)
        {
            _context = context;
        }

        public async Task<ResponseCreateETL> Register(UserETL user)
        {
            using var connection = _context.CreateConnection();

            var parameters = new DynamicParameters();

            // Parámetros de entrada
            parameters.Add("@Name", user.Name, DbType.String, ParameterDirection.Input);
            parameters.Add("@Email", user.Email, DbType.String, ParameterDirection.Input);
            parameters.Add("@PasswordHash", user.PasswordHash, DbType.String, ParameterDirection.Input);
            parameters.Add("@Role", user.Role, DbType.String, ParameterDirection.Input);
            parameters.Add("@Phone", user.Phone, DbType.String, ParameterDirection.Input);

            // Parámetros de salida
            parameters.Add("@UserId", dbType: DbType.Int32, direction: ParameterDirection.Output);
            parameters.Add("@Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            parameters.Add("@Message", dbType: DbType.String, size: 255, direction: ParameterDirection.Output);

            try
            {
                await connection.ExecuteAsync(
                    "sp_CreateUser",
                    parameters,
                    commandType: CommandType.StoredProcedure
                );

                // Obtener los valores de salida
                var success = parameters.Get<bool>("@Success");
                var userId = parameters.Get<int>("@UserId");
                var message = parameters.Get<string>("@Message");

                return new ResponseCreateETL
                {
                    Success = success,
                    UserId = userId,
                    Message = message
                };
            }
            catch (Exception ex)
            {
                return new ResponseCreateETL
                {
                    Success = false,
                    UserId = 0,
                    Message = $"Error en DAL: {ex.Message}"
                };
            }
        }
    }
}
