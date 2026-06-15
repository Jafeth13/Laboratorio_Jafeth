using Dapper;
using Domain.Entidades.User;
using Domain.Interfaces.GetUserByEmail;
using Infrastructure.Persistence;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Repositories.GetUserByEmail
{
    public class GetUserByEmailDAL : IGetUserByEmailDAL
    {
        private readonly DapperContext _context;

        public GetUserByEmailDAL(DapperContext context)
        {
            _context = context;
        }

        public async Task<UserETL> GetUserByEmail(string email)
        {
            using var connection = _context.CreateConnection();
            var parameters = new { Email = email };

            return await connection.QueryFirstOrDefaultAsync<UserETL>(
                "sp_GetUserByEmail",
                parameters,
                commandType: CommandType.StoredProcedure
            );
        }

    }
}
