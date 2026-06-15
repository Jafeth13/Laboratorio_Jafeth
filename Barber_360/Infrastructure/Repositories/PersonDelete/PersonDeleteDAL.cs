using Dapper;
using System.Data;
using Domain.Interfaces.PersonDelete;
using Infrastructure.Persistence;

namespace Infrastructure.Repositories.Person
{
    public class PersonDeleteDAL : IPersonDeleteDAL
    {
        private readonly DapperContext _context;

        public PersonDeleteDAL(DapperContext context)
        {
            _context = context;
        }

        public async Task<int> DeleteAsync(int id)
        {
            if (id <= 0)
                throw new ArgumentException("Id inválido");

            using IDbConnection db = _context.CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@pi_Id", id);

            var result = await db.ExecuteScalarAsync<int>(
                "sp_DeletePerson",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return result;
        }
    }
}